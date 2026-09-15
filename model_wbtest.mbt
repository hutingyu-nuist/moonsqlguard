///|
test "bounded token preserves bytes including NUL" {
  let t = token("n", 4, Bytes::make(40, b'a'))
  assert_eq(t.value.length(), 31)
  assert_eq(t.pos, 4)
  assert_eq(upper_text(b"sElEcT"), "SELECT")
  assert_eq(byte_slice(b"a\x00b", 1, 3), b"\x00b")
  assert_true(white(160))
  assert_true(digit(57))
  assert_true(contains_byte(43, "+-"))
}
