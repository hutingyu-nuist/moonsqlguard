///|
fn has_byte(data : Bytes, code : Int) -> Bool {
  let mut i = 0
  while i < data.length() {
    if data[i].to_int() == code {
      return true
    }
    i += 1
  }
  false
}

///|
fn find_slice(hay : Bytes, needle : Bytes) -> Bool {
  if needle.length() > hay.length() {
    return false
  }
  let last = hay.length() - needle.length()
  for i = 0; i <= last; i = i + 1 {
    let mut j = 0
    while j < needle.length() && hay[i + j] == needle[j] {
      j += 1
    }
    if j == needle.length() {
      return true
    }
  }
  false
}

///|
fn data_at(data : Bytes, i : Int) -> Int {
  if i >= 0 && i < data.length() {
    data[i].to_int()
  } else {
    0
  }
}

///|
fn pattern_codes(pattern : String) -> Array[Int] {
  let out : Array[Int] = []
  for c in pattern {
    out.push(c.to_int())
  }
  out
}

///|
fn v1_key(pattern : String) -> String {
  let s = StringBuilder::new()
  s.write_char('0')
  for c in pattern {
    s.write_char(upper(c.to_int()).unsafe_to_char())
  }
  s.to_string()
}

///|
fn starts_with_into(value : Bytes) -> Bool {
  value.length() >= 4 && upper_text(byte_slice(value, 0, 4)) == "INTO"
}

///|
fn blacklisted(fp : Fingerprint) -> Bool {
  fp.pattern.length() >= 1 &&
  lookup_entries.get(v1_key(fp.pattern)).unwrap_or("") == "F"
}

///|
fn not_whitelist(data : Bytes, fp : Fingerprint) -> Bool {
  let codes = pattern_codes(fp.pattern)
  let tlen = codes.length()
  if tlen > 1 && codes[tlen - 1] == 99 && find_slice(data, b"sp_password") {
    return true
  }
  match tlen {
    2 => {
      if codes[1] == 85 {
        return fp.consumed_tokens != 2
      }
      if fp.tokens[1].at(0) == 35 {
        return false
      }
      if fp.tokens[0].kind == "n" &&
        fp.tokens[1].kind == "c" &&
        fp.tokens[1].at(0) != 47 {
        return false
      }
      if fp.tokens[0].kind == "1" &&
        fp.tokens[1].kind == "c" &&
        fp.tokens[1].at(0) == 47 {
        return true
      }
      if fp.tokens[0].kind == "1" && fp.tokens[1].kind == "c" {
        if fp.consumed_tokens > 2 {
          return true
        }
        let ch = data_at(data, fp.tokens[0].value.length())
        if ch <= 32 {
          return true
        }
        if ch == 47 && data_at(data, fp.tokens[0].value.length() + 1) == 42 {
          return true
        }
        if ch == 45 && data_at(data, fp.tokens[0].value.length() + 1) == 45 {
          return true
        }
        return false
      }
      if fp.tokens[1].value.length() > 2 && fp.tokens[1].at(0) == 45 {
        return false
      }
      true
    }
    3 =>
      if fp.pattern == "sos" || fp.pattern == "s&s" {
        if fp.tokens[0].open == 0 &&
          fp.tokens[2].close == 0 &&
          fp.tokens[0].close == fp.tokens[2].open {
          return true
        }
        if fp.consumed_tokens == 3 {
          return false
        }
        false
      } else if fp.pattern == "s&n" ||
        fp.pattern == "n&1" ||
        fp.pattern == "1&1" ||
        fp.pattern == "1&v" ||
        fp.pattern == "1&s" {
        fp.consumed_tokens != 3
      } else if fp.tokens[1].kind == "k" {
        fp.tokens[1].value.length() >= 5 && starts_with_into(fp.tokens[1].value)
      } else {
        true
      }
    _ => true
  }
}

///|
fn check_fingerprint(data : Bytes, fp : Fingerprint) -> Bool {
  blacklisted(fp) && not_whitelist(data, fp)
}

///|
/// One parsing context after folding, blacklist lookup and whitelist filtering.
pub(all) struct Detection {
  hit : Bool
  pattern : String
  quote : Quote
  dialect : Dialect
  tokens : Array[Token]
} derive(Eq, Debug)

///|
priv struct Probe {
  detection : Detection
  hashes : Int
  ambiguous : Int
}

///|
fn empty_detection() -> Detection {
  { hit: false, pattern: "", quote: None, dialect: Ansi, tokens: [], }
}

///|
fn probe(data : Bytes, dialect : Dialect, quote : Quote) -> Probe {
  let fp = fingerprint(data, dialect~, quote~)
  {
    detection: {
      hit: check_fingerprint(data, fp),
      pattern: fp.pattern,
      quote,
      dialect,
      tokens: fp.tokens,
    },
    hashes: fp.hashes,
    ambiguous: fp.ambiguous_comments,
  }
}

///|
fn mysql_reparse(p : Probe) -> Bool {
  p.ambiguous > 0 || p.hashes > 0
}

///|
/// Fold and classify input in one explicit quote/dialect context.
pub fn inspect_context(
  data : Bytes,
  dialect? : Dialect = Ansi,
  quote? : Quote = None,
) -> Detection {
  probe(data, dialect, quote).detection
}

///|
/// Walk the upstream no-quote / single-quote / double-quote contexts.
pub fn inspect(data : Bytes) -> Detection {
  if data.length() == 0 {
    return empty_detection()
  }
  let first = probe(data, Ansi, None)
  if first.detection.hit {
    return first.detection
  }
  if mysql_reparse(first) {
    let mysql = probe(data, Mysql, None)
    if mysql.detection.hit {
      return mysql.detection
    }
  }
  if has_byte(data, 39) {
    let q = probe(data, Ansi, Single)
    if q.detection.hit {
      return q.detection
    }
    if mysql_reparse(q) {
      let qm = probe(data, Mysql, Single)
      if qm.detection.hit {
        return qm.detection
      }
    }
  }
  if has_byte(data, 34) {
    let dq = probe(data, Mysql, Double)
    if dq.detection.hit {
      return dq.detection
    }
  }
  {
    hit: false,
    pattern: first.detection.pattern,
    quote: None,
    dialect: Ansi,
    tokens: first.detection.tokens,
  }
}

///|
/// True when any upstream detection context classifies the bytes as SQLi.
pub fn is_sqli(data : Bytes) -> Bool {
  inspect(data).hit
}

///|
/// C `libinjection_sqli` fingerprint: folded pattern on hit, otherwise empty.
pub fn sqli_fingerprint(data : Bytes) -> String {
  let d = inspect(data)
  if d.hit {
    d.pattern
  } else {
    ""
  }
}
