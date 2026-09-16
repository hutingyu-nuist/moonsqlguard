///|
test "public dumps match testdriver punctuation for classic payloads" {
  assert_eq(dump_tokens(b"1 OR 1=1"), "1 1\n& OR\n1 1\no =\n1 1")
  assert_eq(dump_folded(b"1 OR 1=1"), "1 1\n& OR\n1 1")
  assert_eq(format_token(tokenize(b"'x'")[0]).contains("s "), true)
}

///|
test "folded dump stays distinct from fingerprint X rewrite" {
  let folded = dump_folded(b"/*!SELECT*/")
  assert_true(folded.length() > 0)
  assert_eq(fingerprint(b"/*!SELECT*/").pattern, "X")
}
