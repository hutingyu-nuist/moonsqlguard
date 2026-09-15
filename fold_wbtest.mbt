///|
test "fold arithmetic and merge keywords" {
  assert_eq(fingerprint(b"1 + 2 + 3").pattern, "1")
  assert_eq(fingerprint(b"'a' 'b'").pattern, "s")
  assert_eq(fingerprint(b"UNION ALL SELECT 1").pattern, "UE1")
  assert_eq(fingerprint(b"/*!SELECT*/").pattern, "X")
  assert_eq(fingerprint(b"(((-1").pattern, "1")
  assert_eq(fingerprint(b"1--comment").pattern, "1c")
  assert_eq(fingerprint(b"1--comment").ambiguous_comments, 1)
  assert_eq(fingerprint(b"1 # comment", dialect=Mysql).hashes, 1)
}

///|
test "fold preserves independent token values" {
  let f = fingerprint(b"1 OR 1=1")
  assert_eq(f.pattern, "1&1")
  assert_true(f.consumed_tokens >= 5)
  assert_eq(f.tokens[0].value, b"1")
}
