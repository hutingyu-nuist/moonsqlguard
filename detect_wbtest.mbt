///|
test "blacklist and whitelist follow folded fingerprints" {
  let fp = fingerprint(b"1 OR 1=1")
  assert_eq(fp.pattern, "1&1")
  assert_true(blacklisted(fp))
  assert_true(check_fingerprint(b"1 OR 1=1", fp))
  let benign = fingerprint(b"hello")
  assert_false(blacklisted(benign) && not_whitelist(b"hello", benign))
  assert_eq(v1_key("1c"), "01C")
  assert_eq(v1_key("X"), "0X")
}

///|
test "number-comment whitelist keeps slash comments and bare dashes" {
  assert_true(check_fingerprint(b"1/* yes */", fingerprint(b"1/* yes */")))
  assert_true(check_fingerprint(b"1--", fingerprint(b"1--")))
  assert_false(check_fingerprint(b"1# blah blah", fingerprint(b"1# blah blah")))
  assert_false(check_fingerprint(b"foo--", fingerprint(b"foo--")))
  assert_true(check_fingerprint(b"foo/* yes */", fingerprint(b"foo/* yes */")))
}
