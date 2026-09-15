///|
fn Token::duplicate(self : Token) -> Token {
  {
    kind: self.kind,
    pos: self.pos,
    value: self.value,
    open: self.open,
    close: self.close,
    count: self.count,
  }
}

///|
fn Token::at(self : Token, i : Int) -> Int {
  if i < self.value.length() {
    self.value[i].to_int()
  } else {
    0
  }
}

///|
fn unary(t : Token) -> Bool {
  t.kind == "o" &&
  (
    t.value == b"+" ||
    t.value == b"-" ||
    t.value == b"!" ||
    t.value == b"~" ||
    t.value == b"!!" ||
    upper_text(t.value) == "NOT"
  )
}

///|
fn arithmetic(t : Token) -> Bool {
  t.kind == "o" && t.value.length() == 1 && contains_byte(t.at(0), "*/-+%")
}

///|
fn merge_words(a : Token, b : Token) -> Bool {
  if !["k", "n", "o", "U", "f", "E", "T", "t"].contains(a.kind) ||
    !["k", "n", "o", "U", "f", "E", "T", "t", "&"].contains(b.kind) {
    return false
  }
  let length = a.value.length() + b.value.length() + 1
  if length >= 32 {
    return false
  }
  let v = Bytes::makei(length, i => {
    if i < a.value.length() {
      a.value[i]
    } else if i == a.value.length() {
      b' '
    } else {
      b.value[i - a.value.length() - 1]
    }
  })
  let k = lookup(v)
  if k == "" {
    false
  } else {
    a.kind = k
    a.value = v
    true
  }
}
