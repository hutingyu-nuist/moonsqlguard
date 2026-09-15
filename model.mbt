// Port of libinjection SQLi; BSD-3-Clause, see THIRD_PARTY.md.

///|
/// Values retain at most 31 bytes, matching upstream stoken_t.
pub(all) struct Token {
  mut kind : String
  pos : Int
  mut value : Bytes
  mut open : Int
  mut close : Int
  mut count : Int
} derive(Eq, Debug)

///|
pub(all) enum Dialect {
  Ansi
  Mysql
} derive(Eq, Debug)

///|
pub(all) enum Quote {
  None
  Single
  Double
} derive(Eq, Debug)

///|
fn token(kind : String, pos : Int, value : Bytes) -> Token {
  {
    kind,
    pos,
    value: Bytes::makei(Int::min(value.length(), 31), i => value[i]),
    open: 0,
    close: 0,
    count: 0,
  }
}

///|
fn ascii(b : Int) -> String {
  b.unsafe_to_char().to_string()
}

///|
fn upper(b : Int) -> Int {
  if b >= 97 && b <= 122 {
    b - 32
  } else {
    b
  }
}

///|
fn upper_text(b : Bytes) -> String {
  let s = StringBuilder::new()
  for x in b {
    s.write_char(upper(x.to_int()).unsafe_to_char())
  }
  s.to_string()
}

///|
fn byte_slice(b : Bytes, start : Int, end : Int) -> Bytes {
  Bytes::makei(end - start, i => b[start + i])
}

///|
fn white(c : Int) -> Bool {
  c == 0 || c == 32 || (c >= 9 && c <= 13) || c == 160
}

///|
fn digit(c : Int) -> Bool {
  c >= 48 && c <= 57
}

///|
fn contains_byte(c : Int, s : String) -> Bool {
  s.contains(ascii(c))
}
