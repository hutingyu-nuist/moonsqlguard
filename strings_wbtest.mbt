///|
test "quoted strings track escaped and doubled delimiters" {
  let s = scanner(b"'a''b' tail", Ansi, None)
  let t = s.string_core(39, 1)
  assert_eq(t.value, b"a''b")
  assert_eq(t.open, 39)
  assert_eq(t.close, 39)
  assert_eq(s.pos, 6)
  let u = scanner(b"unfinished", Ansi, Single).string_core(39, 0)
  assert_eq(u.open, 0)
  assert_eq(u.close, 0)
  assert_eq(u.value, b"unfinished")
}

///|
test "words resolve prefixes and quoted variable metadata" {
  let s = scanner(b"SELECT.foo", Ansi, None)
  assert_eq(s.word().kind, "E")
  assert_eq(s.pos, 6)
  assert_eq(scanner(b"ordinary.field", Ansi, None).word().kind, "n")
  let t = scanner(b"@@'name'", Ansi, None).variable()
  assert_eq(t.count, 2)
  assert_eq(t.kind, "v")
  assert_eq(t.value, b"name")
  assert_eq(
    scanner(b"[schema name]", Ansi, None).bracket().value,
    b"[schema name]",
  )
  assert_eq(scanner(b"`table`", Ansi, None).tick().kind, "n")
}
