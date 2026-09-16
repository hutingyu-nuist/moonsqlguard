///|
test "inspect walks quote contexts and empty input" {
  assert_false(is_sqli(b""))
  assert_eq(sqli_fingerprint(b""), "")
  assert_false(is_sqli(b"hello"))
  assert_false(is_sqli(b"1"))
  assert_true(is_sqli(b"1 OR 1=1"))
  assert_eq(sqli_fingerprint(b"1 OR 1=1"), "1&1")
  assert_true(is_sqli(b"1 = 1 OR 1"))
  assert_eq(sqli_fingerprint(b"1 = 1 OR 1"), "1&1")
  assert_true(is_sqli(b"UNION SELECT 1"))
  assert_true(is_sqli(b"1--"))
  assert_eq(sqli_fingerprint(b"1--"), "1c")
  assert_false(is_sqli(b"foo 'bar' \"zap\""))
  assert_eq(sqli_fingerprint(b"1 /* /* */ */ 2"), "X")
}

///|
test "inspect uses quote and mysql reparse contexts" {
  assert_eq(sqli_fingerprint(b"1 = '1' OR 1"), "1os&1")
  assert_eq(sqli_fingerprint(b"1 = \"1\" OR 1"), "1os&1")
  assert_eq(sqli_fingerprint(b"foo' OR 'BAR"), "s&s")
  assert_true(
    inspect(b"foo' OR 'BAR").quote == Single || inspect(b"foo' OR 'BAR").hit,
  )
  assert_eq(sqli_fingerprint(b"foo--"), "")
  assert_eq(sqli_fingerprint(b"1# blah blah"), "")
  assert_false(is_sqli(Bytes::make(1, b'\x00')))
}
