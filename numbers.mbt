///|
fn Scanner::number(self : Scanner) -> Token? {
  let start = self.pos
  let mut end = start
  if self.at(start) == 48 &&
    (upper(self.at(start + 1)) == 88 || upper(self.at(start + 1)) == 66) {
    let digits = if upper(self.at(start + 1)) == 88 {
      "0123456789ABCDEFabcdef"
    } else {
      "01"
    }
    end = self.span(start + 2, digits)
    return Some(self.take(if end == start + 2 { "n" } else { "1" }, start, end))
  }
  while digit(self.at(end)) {
    end += 1
  }
  if self.at(end) == 46 {
    end += 1
    while digit(self.at(end)) {
      end += 1
    }
    if end == start + 1 {
      return Some(self.take(".", start, end))
    }
  }
  let mut have_e = false
  let mut have_exp = false
  if upper(self.at(end)) == 69 {
    have_e = true
    end += 1
    if self.at(end) == 43 || self.at(end) == 45 {
      end += 1
    }
    while digit(self.at(end)) {
      have_exp = true
      end += 1
    }
  }
  if upper(self.at(end)) == 68 || upper(self.at(end)) == 70 {
    let next = self.at(end + 1)
    if end + 1 == self.data.length() ||
      white(next) ||
      next == 59 ||
      upper(next) == 85 {
      end += 1
    }
  }
  self.pos = end
  if have_e && !have_exp {
    None
  } else {
    Some(self.take("1", start, end))
  }
}

///|
fn Scanner::binary_string(self : Scanner, binary : Bool) -> Token {
  let start = self.pos
  if start + 2 >= self.data.length() || self.at(start + 1) != 39 {
    return self.word()
  }
  let end = self.span(
    start + 2,
    if binary {
      "01"
    } else {
      "0123456789ABCDEFabcdef"
    },
  )
  if self.at(end) != 39 {
    return self.word()
  }
  self.take("1", start, end + 1)
}

///|
fn Scanner::qstring(self : Scanner, offset : Int) -> Token {
  let start = self.pos + offset
  if start + 2 >= self.data.length() ||
    upper(self.at(start)) != 81 ||
    self.at(start + 1) != 39 ||
    self.at(start + 2) < 33 {
    return self.word()
  }
  let ch = self.at(start + 2)
  let delim = match ch {
    40 => 41
    91 => 93
    123 => 125
    60 => 62
    _ => ch
  }
  let end = self.find_pair(start + 3, self.data.length(), delim, 39)
  let t = self.take(
    "s",
    start + 3,
    if end < 0 {
      self.data.length()
    } else {
      end
    },
  )
  t.open = 113
  if end >= 0 {
    t.close = 113
    self.pos = end + 2
  }
  t
}

///|
fn Scanner::money(self : Scanner) -> Token {
  let start = self.pos
  if start + 1 == self.data.length() {
    return self.take("n", start, start + 1)
  }
  let end = self.span(start + 1, "0123456789.,")
  if end > start + 1 {
    if end == start + 2 && self.at(start + 1) == 46 {
      return self.word()
    }
    return self.take("1", start, end)
  }
  let tag_end = if self.at(start + 1) == 36 {
    start + 1
  } else {
    self.span(start + 1, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  }
  if self.at(tag_end) != 36 || tag_end == start {
    return self.take("n", start, start + 1)
  }
  if tag_end == start + 1 && self.at(start + 1) != 36 {
    return self.take("n", start, start + 1)
  }
  let length = tag_end - start + 1
  let mut close = tag_end + 1
  while close + length <= self.data.length() {
    if byte_slice(self.data, close, close + length) ==
      byte_slice(self.data, start, tag_end + 1) {
      break
    }
    close += 1
  }
  let found = close + length <= self.data.length()
  let t = self.take(
    "s",
    tag_end + 1,
    if found {
      close
    } else {
      self.data.length()
    },
  )
  t.open = 36
  if found {
    t.close = 36
    self.pos = close + length
  }
  t
}
