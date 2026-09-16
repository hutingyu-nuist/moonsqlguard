///|
fn dump_one(label : String, data : Bytes) -> Unit {
  println(label)
  println("fingerprint " + @sqlg.sqli_fingerprint(data))
  println(@sqlg.dump_folded(data))
  println("---")
}

///|
fn main {
  dump_one("or", b"1 OR 1=1")
  dump_one("union", b"UNION SELECT 1")
  dump_one("hello", b"hello")
}
