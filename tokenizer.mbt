///|
fn Scanner::next(self : Scanner) -> Token? {
  if self.pos == 0 && self.data.length() > 0 && self.quote != None {
    self.tokens += 1
    return Some(self.string_core(if self.quote == Single { 39 } else { 34 }, 0))
  }
  while self.pos < self.data.length() {
    let start = self.pos
    let ch = self.at(start)
    let t : Token = match character_dispatch[ch] {
      "white" => {
        self.pos += 1
        continue
      }
      "number" =>
        match self.number() {
          Some(t) => t
          None => continue
        }
      "word" => self.word()
      "string" => self.string_core(ch, 1)
      "operator1" => self.take("o", start, start + 1)
      "operator2" => self.operator()
      "char" => self.take(ascii(ch), start, start + 1)
      "other" => self.take("?", start, start + 1)
      "hash" => self.hash()
      "dash" => self.dash()
      "slash" => self.slash()
      "backslash" =>
        if self.at(start + 1) == 78 {
          self.take("1", start, start + 2)
        } else {
          self.take("\\", start, start + 1)
        }
      "tick" => self.tick()
      "var" => self.variable()
      "money" => self.money()
      "bword" => self.bracket()
      "bstring" => self.binary_string(true)
      "xstring" => self.binary_string(false)
      "estring" =>
        if start + 2 < self.data.length() && self.at(start + 1) == 39 {
          self.string_core(39, 2)
        } else {
          self.word()
        }
      "ustring" =>
        if self.at(start + 1) == 38 && self.at(start + 2) == 39 {
          self.pos += 2
          let t = self.string_core(39, 1)
          t.open = 117
          if t.close == 39 {
            t.close = 117
          }
          t
        } else {
          self.word()
        }
      "qstring" => self.qstring(0)
      "nqstring" =>
        if start + 2 < self.data.length() && self.at(start + 1) == 39 {
          self.string_core(39, 2)
        } else {
          self.qstring(1)
        }
      _ => self.take("?", start, start + 1)
    }
    self.tokens += 1
    return Some(t)
  }
  None
}

///|
/// Tokenize bytes without URL decoding or text normalization.
pub fn tokenize(
  data : Bytes,
  dialect? : Dialect = Ansi,
  quote? : Quote = None,
) -> Array[Token] {
  let s = scanner(data, dialect, quote)
  let out = []
  while s.next() is Some(t) {
    out.push(t)
  }
  out
}
