///|
test "numeric dialect forms preserve upstream token consumption" {
  assert_eq(scanner(b"0x123", Ansi, None).number().unwrap().value, b"0x123")
  assert_eq(scanner(b"0x", Ansi, None).number().unwrap().kind, "n")
  assert_eq(scanner(b".25e-3", Ansi, None).number().unwrap().kind, "1")
  assert_eq(scanner(b".", Ansi, None).number().unwrap().kind, ".")
  assert_eq(scanner(b"1e+", Ansi, None).number(), None)
  assert_eq(scanner(b"B'0101'", Ansi, None).binary_string(true).kind, "1")
  assert_eq(scanner(b"X'FF'", Ansi, None).binary_string(false).value, b"X'FF'")
}

///|
test "Oracle and dollar quoted strings preserve delimiters" {
  let t = scanner(b"q'[hello]'", Ansi, None).qstring(0)
  assert_eq(t.value, b"hello")
  assert_eq(t.close, 113)
  assert_eq(scanner(b"nq'<hello>'", Ansi, None).qstring(1).value, b"hello")
  assert_eq(scanner(b"$tag$body$tag$", Ansi, None).money().value, b"body")
  assert_eq(scanner(b"$$body$$", Ansi, None).money().value, b"body")
  assert_eq(scanner(b"$1,234.00", Ansi, None).money().kind, "1")
  assert_eq(scanner(b"$tag$unfinished", Ansi, None).money().close, 0)
}
