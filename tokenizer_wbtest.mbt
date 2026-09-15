///|
test "public tokenizer handles zero bytes and dialect contexts" {
  let ts = tokenize(b"SELECT\x00a FROM t -- comment")
  assert_eq(ts.map(t => t.kind), ["E", "n", "k", "n", "c"])
  assert_eq(tokenize(b"", quote=Single).length(), 0)
  assert_eq(tokenize(b"hello' tail", quote=Single)[0].open, 0)
  assert_eq(tokenize(b"U&'hello'")[0].close, 117)
  assert_eq(tokenize(b"N'hello'")[0].value, b"hello")
}

///|
test "every byte dispatch advances" {
  for i = 0; i < 256; i = i + 1 {
    let ts = tokenize(Bytes::make(1, i.to_byte()))
    assert_true(ts.length() <= 1)
  }
}
