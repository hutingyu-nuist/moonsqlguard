// Testdriver-style token dumps; BSD-3-Clause, matching pinned libinjection output.

///|
fn latin1(value : Bytes) -> String {
  let s = StringBuilder::new()
  for x in value {
    s.write_char(x.to_int().unsafe_to_char())
  }
  s.to_string()
}

///|
fn rtrim_text(s : String) -> String {
  let codes : Array[Int] = []
  for c in s {
    codes.push(c.to_int())
  }
  let mut n = codes.length()
  while n > 0 {
    let ch = codes[n - 1]
    if ch == 32 || ch == 10 || ch == 9 || ch == 13 {
      n -= 1
    } else {
      break
    }
  }
  let out = StringBuilder::new()
  for i = 0; i < n; i = i + 1 {
    out.write_char(codes[i].unsafe_to_char())
  }
  out.to_string()
}

///|
fn dump_string(t : Token) -> String {
  let s = StringBuilder::new()
  if t.open != 0 {
    s.write_char(t.open.unsafe_to_char())
  }
  s.write_string(latin1(t.value))
  if t.close != 0 {
    s.write_char(t.close.unsafe_to_char())
  }
  s.to_string()
}

///|
/// One testdriver line: `kind value`, with quote marks restored for strings.
pub fn format_token(t : Token) -> String {
  let s = StringBuilder::new()
  s.write_string(t.kind)
  s.write_char(' ')
  if t.kind == "s" {
    s.write_string(dump_string(t))
  } else if t.kind == "v" {
    if t.count >= 1 {
      s.write_char('@')
    }
    if t.count == 2 {
      s.write_char('@')
    }
    s.write_string(dump_string(t))
  } else {
    s.write_string(latin1(t.value))
  }
  s.to_string()
}

///|
/// Tokenize and dump in testdriver order. Trailing whitespace is trimmed.
pub fn dump_tokens(
  data : Bytes,
  dialect? : Dialect = Ansi,
  quote? : Quote = None,
) -> String {
  let s = StringBuilder::new()
  for t in tokenize(data, dialect~, quote~) {
    s.write_string(format_token(t))
    s.write_char('\n')
  }
  rtrim_text(s.to_string())
}

///|
fn folded_tokens(
  data : Bytes,
  dialect : Dialect,
  quote : Quote,
) -> Array[Token] {
  let sf = scanner(data, dialect, quote)
  let vec = Array::makei(8, _ => token("", 0, b""))
  let n = fold_engine(sf, vec)
  Array::makei(n, i => vec[i].duplicate())
}

///|
/// Dump fold_engine tokens. This is not `fingerprint()`: no empty-backtick rewrite.
pub fn dump_folded(
  data : Bytes,
  dialect? : Dialect = Ansi,
  quote? : Quote = None,
) -> String {
  let s = StringBuilder::new()
  for t in folded_tokens(data, dialect, quote) {
    s.write_string(format_token(t))
    s.write_char('\n')
  }
  rtrim_text(s.to_string())
}
