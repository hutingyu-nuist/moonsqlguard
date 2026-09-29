///|
test "public detector API classifies representative inputs" {
  assert_true(@moonsqlguard.is_sqli(b"1 OR 1=1"))
  assert_eq(@moonsqlguard.sqli_fingerprint(b"1 OR 1=1"), "1&1")
  assert_true(!@moonsqlguard.is_sqli(b"hunter2"))
  assert_eq(
    @moonsqlguard.format_detection(@moonsqlguard.inspect(b"admin'--")),
    "sqli sc",
  )
}

///|
test "public field scan keeps input order and drops clean fields" {
  let hits = @moonsqlguard.scan_fields([
    { name: "user", value: b"alice", },
    { name: "query", value: b"1 OR 1=1", },
    { name: "id", value: b"1--", },
  ])
  assert_eq(hits.length(), 2)
  assert_eq(hits[0].name, "query")
  assert_eq(hits[1].name, "id")
}

///|
test "public token dump is stable for a small fixture" {
  assert_eq(
    @moonsqlguard.dump_folded(b"UNION SELECT 1"),
    "U UNION\nE SELECT\n1 1",
  )
  assert_eq(@moonsqlguard.dump_folded(b"hello"), "n hello")
}
