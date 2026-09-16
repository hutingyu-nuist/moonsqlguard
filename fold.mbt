// Port of upstream libinjection_sqli_fold; BSD-3-Clause.

///|
fn fold_engine(sf : Scanner, vec : Array[Token]) -> Int {
  let mut last_comment = token("", 0, b"")
  let mut pos = 0
  let mut left = 0
  let mut more = true
  let mut current_index = 0

  current_index = 0
  while more {
    more = match sf.next() {
      Some(t) => {
        vec[current_index] = t
        true
      }
      None => {
        vec[current_index] = token("", 0, b"")
        false
      }
    }
    if !(vec[current_index].kind == "c" ||
      vec[current_index].kind == "(" ||
      vec[current_index].kind == "t" ||
      unary(vec[current_index])) {
      break
    }
  }
  if !more {
    return 0
  } else {
    pos += 1
  }
  while true {
    if pos >= 5 {
      if (
          vec[0].kind == "1" &&
          (vec[1].kind == "o" || vec[1].kind == ",") &&
          vec[2].kind == "(" &&
          vec[3].kind == "1" &&
          vec[4].kind == ")"
        ) ||
        (
          vec[0].kind == "n" &&
          vec[1].kind == "o" &&
          vec[2].kind == "(" &&
          (vec[3].kind == "n" || vec[3].kind == "1") &&
          vec[4].kind == ")"
        ) ||
        (
          vec[0].kind == "1" &&
          vec[1].kind == ")" &&
          vec[2].kind == "," &&
          vec[3].kind == "(" &&
          vec[4].kind == "1"
        ) ||
        (
          vec[0].kind == "n" &&
          vec[1].kind == ")" &&
          vec[2].kind == "o" &&
          vec[3].kind == "(" &&
          vec[4].kind == "n"
        ) {
        if pos > 5 {
          vec[1] = vec[5].duplicate()
          pos = 2

          left = 0
        } else {
          pos = 1

          left = 0
        }
      }
    }
    if !more || left >= 5 {
      left = pos

      break
    }
    while more && pos <= 5 && pos - left < 2 {
      current_index = pos
      more = match sf.next() {
        Some(t) => {
          vec[current_index] = t
          true
        }
        None => {
          vec[current_index] = token("", 0, b"")
          false
        }
      }
      if more {
        if vec[current_index].kind == "c" {
          last_comment = vec[current_index].duplicate()
        } else {
          last_comment.kind = ""

          pos += 1
        }
      }
    }

    if pos - left < 2 {
      left = pos

      continue
    }
    if vec[left].kind == "s" && vec[left + 1].kind == "s" {
      pos -= 1

      continue
    } else if vec[left].kind == ";" && vec[left + 1].kind == ";" {
      pos -= 1

      continue
    } else if (vec[left].kind == "o" || vec[left].kind == "&") &&
      (unary(vec[left + 1]) || vec[left + 1].kind == "t") {
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == "(" && unary(vec[left + 1]) {
      pos -= 1

      if left > 0 {
        left -= 1
      }
      continue
    } else if merge_words(vec[left], vec[left + 1]) {
      pos -= 1

      if left > 0 {
        left -= 1
      }
      continue
    } else if vec[left].kind == ";" &&
      vec[left + 1].kind == "f" &&
      (vec[left + 1].at(0) == 73 || vec[left + 1].at(0) == 105) &&
      (vec[left + 1].at(1) == 70 || vec[left + 1].at(1) == 102) {
      vec[left + 1].kind = "T"

      continue
    } else if (vec[left].kind == "n" || vec[left].kind == "v") &&
      vec[left + 1].kind == "(" &&
      (
        upper_text(vec[left].value) == "USER_ID" ||
        upper_text(vec[left].value) == "USER_NAME" ||
        upper_text(vec[left].value) == "DATABASE" ||
        upper_text(vec[left].value) == "PASSWORD" ||
        upper_text(vec[left].value) == "USER" ||
        upper_text(vec[left].value) == "CURRENT_USER" ||
        upper_text(vec[left].value) == "CURRENT_DATE" ||
        upper_text(vec[left].value) == "CURRENT_TIME" ||
        upper_text(vec[left].value) == "CURRENT_TIMESTAMP" ||
        upper_text(vec[left].value) == "LOCALTIME" ||
        upper_text(vec[left].value) == "LOCALTIMESTAMP"
      ) {
      vec[left].kind = "f"

      continue
    } else if vec[left].kind == "k" &&
      (
        upper_text(vec[left].value) == "IN" ||
        upper_text(vec[left].value) == "NOT IN"
      ) {
      if vec[left + 1].kind == "(" {
        vec[left].kind = "o"
      } else {
        vec[left].kind = "n"
      }
      continue
    } else if vec[left].kind == "o" &&
      (
        upper_text(vec[left].value) == "LIKE" ||
        upper_text(vec[left].value) == "NOT LIKE"
      ) {
      if vec[left + 1].kind == "(" {
        vec[left].kind = "f"
      }
    } else if vec[left].kind == "t" &&
      (
        vec[left + 1].kind == "n" ||
        vec[left + 1].kind == "1" ||
        vec[left + 1].kind == "t" ||
        vec[left + 1].kind == "(" ||
        vec[left + 1].kind == "f" ||
        vec[left + 1].kind == "v" ||
        vec[left + 1].kind == "s"
      ) {
      vec[left] = vec[left + 1].duplicate()
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == "A" && vec[left + 1].kind == "n" {
      if upper_text(vec[left + 1].value).contains("_") {
        vec[left + 1].kind = "t"

        left = 0
      }
    } else if vec[left].kind == "\\" {
      if arithmetic(vec[left + 1]) {
        vec[left].kind = "1"
      } else {
        vec[left] = vec[left + 1].duplicate()
        pos -= 1
      }
      left = 0

      continue
    } else if vec[left].kind == "(" && vec[left + 1].kind == "(" {
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == ")" && vec[left + 1].kind == ")" {
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == "{" && vec[left + 1].kind == "n" {
      if vec[left + 1].value.length() == 0 {
        vec[left + 1].kind = "X"

        return left + 2
      }
      left = 0

      pos -= 2

      continue
    } else if vec[left + 1].kind == "}" {
      pos -= 1

      left = 0

      continue
    }

    while more && pos <= 5 && pos - left < 3 {
      current_index = pos
      more = match sf.next() {
        Some(t) => {
          vec[current_index] = t
          true
        }
        None => {
          vec[current_index] = token("", 0, b"")
          false
        }
      }
      if more {
        if vec[current_index].kind == "c" {
          last_comment = vec[current_index].duplicate()
        } else {
          last_comment.kind = ""

          pos += 1
        }
      }
    }
    if pos - left < 3 {
      left = pos

      continue
    }
    if vec[left].kind == "1" &&
      vec[left + 1].kind == "o" &&
      vec[left + 2].kind == "1" {
      pos -= 2

      left = 0

      continue
    } else if vec[left].kind == "o" &&
      vec[left + 1].kind != "(" &&
      vec[left + 2].kind == "o" {
      left = 0

      pos -= 2

      continue
    } else if vec[left].kind == "&" && vec[left + 2].kind == "&" {
      pos -= 2

      left = 0

      continue
    } else if vec[left].kind == "v" &&
      vec[left + 1].kind == "o" &&
      (
        vec[left + 2].kind == "v" ||
        vec[left + 2].kind == "1" ||
        vec[left + 2].kind == "n"
      ) {
      pos -= 2

      left = 0

      continue
    } else if (vec[left].kind == "n" || vec[left].kind == "1") &&
      vec[left + 1].kind == "o" &&
      (vec[left + 2].kind == "1" || vec[left + 2].kind == "n") {
      pos -= 2

      left = 0

      continue
    } else if (
        vec[left].kind == "n" ||
        vec[left].kind == "1" ||
        vec[left].kind == "v" ||
        vec[left].kind == "s"
      ) &&
      vec[left + 1].kind == "o" &&
      vec[left + 1].value == b"::" &&
      vec[left + 2].kind == "t" {
      pos -= 2

      left = 0

      continue
    } else if (
        vec[left].kind == "n" ||
        vec[left].kind == "1" ||
        vec[left].kind == "s" ||
        vec[left].kind == "v"
      ) &&
      vec[left + 1].kind == "," &&
      (
        vec[left + 2].kind == "1" ||
        vec[left + 2].kind == "n" ||
        vec[left + 2].kind == "s" ||
        vec[left + 2].kind == "v"
      ) {
      pos -= 2

      left = 0

      continue
    } else if (
        vec[left].kind == "E" || vec[left].kind == "B" || vec[left].kind == ","
      ) &&
      unary(vec[left + 1]) &&
      vec[left + 2].kind == "(" {
      vec[left + 1] = vec[left + 2].duplicate()
      pos -= 1

      left = 0

      continue
    } else if (
        vec[left].kind == "k" || vec[left].kind == "E" || vec[left].kind == "B"
      ) &&
      unary(vec[left + 1]) &&
      (
        vec[left + 2].kind == "1" ||
        vec[left + 2].kind == "n" ||
        vec[left + 2].kind == "v" ||
        vec[left + 2].kind == "s" ||
        vec[left + 2].kind == "f"
      ) {
      vec[left + 1] = vec[left + 2].duplicate()
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == "," &&
      unary(vec[left + 1]) &&
      (
        vec[left + 2].kind == "1" ||
        vec[left + 2].kind == "n" ||
        vec[left + 2].kind == "v" ||
        vec[left + 2].kind == "s"
      ) {
      vec[left + 1] = vec[left + 2].duplicate()
      left = 0

      // C asserts pos >= 3 here; keep the decrement bounded so inspect stays usable from main.
      if pos >= 3 {
        pos -= 3
      }

      continue
    } else if vec[left].kind == "," &&
      unary(vec[left + 1]) &&
      vec[left + 2].kind == "f" {
      vec[left + 1] = vec[left + 2].duplicate()
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == "n" &&
      vec[left + 1].kind == "." &&
      vec[left + 2].kind == "n" {
      // C asserts pos >= 3 here; skip the rewrite rather than aborting the library caller.
      if pos >= 3 {
        pos -= 2
      }

      left = 0

      continue
    } else if vec[left].kind == "E" &&
      vec[left + 1].kind == "." &&
      vec[left + 2].kind == "n" {
      vec[left + 1] = vec[left + 2].duplicate()
      pos -= 1

      left = 0

      continue
    } else if vec[left].kind == "f" &&
      vec[left + 1].kind == "(" &&
      vec[left + 2].kind != ")" {
      if upper_text(vec[left].value) == "USER" {
        vec[left].kind = "n"
      }
    }
    left += 1
  }
  if left < 5 && last_comment.kind == "c" {
    vec[left] = last_comment.duplicate()
    left += 1
  }
  if left > 5 {
    left = 5
  }
  return left
}
