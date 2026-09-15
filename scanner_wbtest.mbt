///|
test "comments retain upstream dialect differences" {
  let a = scanner(b"--hello\nnext", Ansi, None)
  assert_eq(a.dash().value, b"--hello")
  assert_eq(a.pos, 8)
  assert_eq(a.dash_ambiguous, 1)
  let m = scanner(b"--hello", Mysql, None)
  assert_eq(m.dash().value, b"-")
  assert_eq(m.pos, 1)
  let h = scanner(b"#hello", Mysql, None)
  assert_eq(h.hash().kind, "c")
  assert_eq(h.hash_count, 1)
}

///|
test "block comments and operator lengths" {
  assert_eq(scanner(b"/* hello */", Ansi, None).slash().kind, "c")
  assert_eq(scanner(b"/*! tagged */", Ansi, None).slash().kind, "X")
  assert_eq(scanner(b"/* a /* b */", Ansi, None).slash().kind, "X")
  assert_eq(scanner(b"/* incomplete", Ansi, None).slash().kind, "c")
  assert_eq(scanner(b"<=>", Ansi, None).operator().value, b"<=>")
  assert_eq(scanner(b"!=", Ansi, None).operator().kind, "o")
}
