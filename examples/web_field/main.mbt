///|
fn show(name : String, data : Bytes) -> Unit {
  println(name + " " + @sqlg.format_detection(@sqlg.inspect(data)))
}

///|
fn main {
  show("username", b"admin'--")
  show("password", b"hunter2")
  show("q", b"1 OR 1=1")
}
