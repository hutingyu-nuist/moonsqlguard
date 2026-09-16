///|
test "scan_fields keeps ordered SQLi hits and drops clean values" {
  let hits = scan_fields([
    { name: "q", value: b"hello", },
    { name: "id", value: b"1 OR 1=1", },
    { name: "note", value: b"1--", },
    { name: "empty", value: b"", },
  ])
  assert_eq(hits.length(), 2)
  assert_eq(hits[0].name, "id")
  assert_eq(hits[0].detection.pattern, "1&1")
  assert_eq(hits[1].name, "note")
  assert_eq(hits[1].detection.pattern, "1c")
  assert_eq(format_detection(inspect(b"hello")), "clean n")
  assert_eq(format_detection(inspect(b"1 OR 1=1")), "sqli 1&1")
}
