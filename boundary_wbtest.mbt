///|
test "percent-encoded quotes stay literal bytes" {
  let encoded = b"admin%27--"
  assert_false(dump_tokens(encoded).contains("'"))
  assert_true(is_sqli(b"admin'--"))
  assert_eq(is_sqli(encoded), false)
  assert_eq(sqli_fingerprint(encoded), "")
}

///|
test "scan_fields drops empty NUL and keeps ordered hits" {
  let hits = scan_fields([
    { name: "empty", value: b"" },
    { name: "nul", value: Bytes::make(1, b'\x00') },
    { name: "q", value: b"1 OR 1=1" },
    { name: "note", value: b"hello" },
    { name: "id", value: b"1--" },
  ])
  assert_eq(hits.length(), 2)
  assert_eq(hits[0].name, "q")
  assert_eq(hits[1].name, "id")
}

///|
test "hash leftover triggers mysql reparse without claiming ansi comments" {
  assert_eq(sqli_fingerprint(b"1# blah blah"), "")
  // C increments hash_count on '#' even in ANSI, which is what triggers MySQL reparse.
  assert_eq(fingerprint(b"1# blah blah").hashes, 1)
  assert_true(fingerprint(b"1# blah blah", dialect=Mysql).hashes >= 1)
  assert_eq(inspect(b"1# blah blah").hit, false)
}

///|
test "public tokenize caps values at 31 bytes" {
  let ts = tokenize(Bytes::make(40, b'A'))
  assert_eq(ts.length(), 1)
  assert_eq(ts[0].value.length(), 31)
}

///|
test "sp_password match is case-sensitive in the raw bytes" {
  assert_true(find_slice(b"1-- sp_password", b"sp_password"))
  assert_false(find_slice(b"1-- SP_PASSWORD", b"sp_password"))
}
