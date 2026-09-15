///|
test "upstream table lookup is case insensitive and exact" {
  assert_eq(lookup(b"select"), "E")
  assert_eq(lookup(b"SELECTED"), "")
  assert_eq(lookup(b""), "")
  assert_eq(lookup(b"SeLeCt\x00"), "")
  assert_eq(lookup(b"0X"), "F")
  assert_eq(lookup_entries.length(), 9352)
}
