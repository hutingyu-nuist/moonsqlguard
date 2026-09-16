// libinjection parser state translated to bounds-checked byte indices.

///|
priv struct Scanner {
  data : Bytes
  dialect : Dialect
  quote : Quote
  mut pos : Int
  mut tokens : Int
  mut dash_ambiguous : Int
  mut hash_count : Int
}

///|
fn scanner(data : Bytes, dialect : Dialect, quote : Quote) -> Scanner {
  { data, dialect, quote, pos: 0, tokens: 0, dash_ambiguous: 0, hash_count: 0, }
}

///|
fn Scanner::at(self : Scanner, i : Int) -> Int {
  if i >= 0 && i < self.data.length() {
    self.data[i].to_int()
  } else {
    -1
  }
}

///|
fn Scanner::take(
  self : Scanner,
  kind : String,
  start : Int,
  end : Int,
) -> Token {
  self.pos = end
  token(kind, start, byte_slice(self.data, start, end))
}

///|
fn Scanner::span(self : Scanner, start : Int, accepted : String) -> Int {
  let mut end = start
  while end < self.data.length() && contains_byte(self.at(end), accepted) {
    end += 1
  }
  end
}

///|
fn Scanner::find_pair(
  self : Scanner,
  start : Int,
  end : Int,
  a : Int,
  b : Int,
) -> Int {
  for i = start; i + 1 < end; i = i + 1 {
    if self.at(i) == a && self.at(i + 1) == b {
      return i
    }
  }
  -1
}

///|
fn Scanner::line_comment(self : Scanner) -> Token {
  let start = self.pos
  let mut end = start
  while end < self.data.length() && self.at(end) != 10 {
    end += 1
  }
  let t = self.take("c", start, end)
  if end < self.data.length() {
    self.pos += 1
  }
  t
}

///|
fn Scanner::operator(self : Scanner) -> Token {
  let start = self.pos
  if self.at(start) == 60 &&
    self.at(start + 1) == 61 &&
    self.at(start + 2) == 62 {
    return self.take("o", start, start + 3)
  }
  if start + 1 < self.data.length() {
    let kind = lookup(byte_slice(self.data, start, start + 2))
    if kind != "" {
      return self.take(kind, start, start + 2)
    }
  }
  self.take(if self.at(start) == 58 { ":" } else { "o" }, start, start + 1)
}

///|
fn Scanner::dash(self : Scanner) -> Token {
  let start = self.pos
  if self.at(start + 1) == 45 {
    if start + 2 == self.data.length() ||
      white(self.at(start + 2)) ||
      self.at(start + 2) == 0 {
      return self.line_comment()
    }
    if self.dialect == Ansi {
      self.dash_ambiguous += 1
      return self.line_comment()
    }
  }
  self.take("o", start, start + 1)
}

///|
fn Scanner::hash(self : Scanner) -> Token {
  self.hash_count += 1
  if self.dialect == Mysql {
    self.line_comment()
  } else {
    self.take("o", self.pos, self.pos + 1)
  }
}

///|
fn Scanner::slash(self : Scanner) -> Token {
  let start = self.pos
  if self.at(start + 1) != 42 {
    return self.take("o", start, start + 1)
  }
  let close = self.find_pair(start + 2, self.data.length(), 42, 47)
  let end = if close < 0 { self.data.length() } else { close + 2 }
  let evil = self.at(start + 2) == 33 ||
    (close >= 0 && self.find_pair(start + 2, close + 1, 47, 42) >= 0)
  self.take(if evil { "X" } else { "c" }, start, end)
}
