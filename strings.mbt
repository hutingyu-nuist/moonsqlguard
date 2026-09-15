// SQL string contexts: retain delimiters and byte offsets without decoding input.
///|
fn Scanner::string_core(self : Scanner, delim : Int, offset : Int) -> Token {
  let start = self.pos + offset
  let mut end = start
  while end < self.data.length() {
    if self.at(end) == delim {
      let mut back = end - 1
      while back >= start && self.at(back) == 92 {
        back -= 1
      }
      if (end - 1 - back) % 2 == 1 {
        end += 1
        continue
      }
      if self.at(end + 1) == delim {
        end += 2
        continue
      }
      let t = self.take("s", start, end)
      t.open = if offset > 0 { delim } else { 0 }
      t.close = delim
      self.pos = end + 1
      return t
    }
    end += 1
  }
  let t = self.take("s", start, end)
  t.open = if offset > 0 { delim } else { 0 }
  t
}

///|
fn Scanner::word(self : Scanner) -> Token {
  let start = self.pos
  let mut end = start
  while end < self.data.length() &&
        self.at(end) != 0 &&
        self.at(end) != 160 &&
        !contains_byte(
          self.at(end),
          " []{}<>:\\?=@!#~+-*/&|^%(),';\t\n\u000b\u000c\r\"",
        ) {
    end += 1
  }
  let t = self.take("n", start, end)
  for i = 0; i < t.value.length(); i = i + 1 {
    if t.value[i] == b'.' || t.value[i] == b'`' {
      let k = lookup(byte_slice(t.value, 0, i))
      if k != "" && k != "n" {
        return self.take(k, start, start + i)
      }
    }
  }
  if end - start < 32 {
    let k = lookup(t.value)
    if k != "" {
      t.kind = k
    }
  }
  t
}

///|
fn Scanner::tick(self : Scanner) -> Token {
  let t = self.string_core(96, 1)
  t.kind = if lookup(t.value) == "f" { "f" } else { "n" }
  t
}

///|
fn Scanner::bracket(self : Scanner) -> Token {
  let start = self.pos
  let mut end = start
  while end < self.data.length() && self.at(end) != 93 {
    end += 1
  }
  if end < self.data.length() {
    end += 1
  }
  self.take("n", start, end)
}

///|
fn Scanner::variable(self : Scanner) -> Token {
  self.pos += 1
  let count = if self.at(self.pos) == 64 {
    self.pos += 1
    2
  } else {
    1
  }
  let start = self.pos
  let ch = self.at(start)
  let t = if ch == 96 {
    self.tick()
  } else if ch == 39 || ch == 34 {
    self.string_core(ch, 1)
  } else {
    let mut end = start
    while end < self.data.length() &&
          self.at(end) != 0 &&
          !contains_byte(
            self.at(end),
            " <>:\\?=@!#~+-*/&|^%(),';\t\n\u000b\u000c\r'`\"",
          ) {
      end += 1
    }
    self.take("v", start, end)
  }
  t.kind = "v"
  t.count = count
  t
}
