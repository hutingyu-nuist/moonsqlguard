///|
test "upstream sqli testdriver fixtures" {
  assert_eq(sqli_fixtures.length(), 50)
  let mut first = ""
  for f in sqli_fixtures {
    let got = sqli_fingerprint(f.input)
    if got != f.expected && first == "" {
      first = f.name + " expected=[" + f.expected + "] got=[" + got + "]"
    }
  }
  assert_eq(first, "")
}

///|
test "upstream folding testdriver fixtures" {
  assert_eq(folding_fixtures.length(), 118)
  let mut first = ""
  for f in folding_fixtures {
    let got = dump_folded(f.input)
    if got != f.expected && first == "" {
      first = f.name + " expected=[" + f.expected + "] got=[" + got + "]"
    }
  }
  assert_eq(first, "")
}

///|
test "upstream tokenizer testdriver fixtures" {
  let mut first = ""
  let mut failed = 0
  for f in token_fixtures {
    let got = dump_tokens(f.input)
    if got != f.expected {
      failed += 1
      if first == "" {
        first = f.name + " expected=[" + f.expected + "] got=[" + got + "]"
      }
    }
  }
  ignore(failed)
  assert_eq(first, "")
}
