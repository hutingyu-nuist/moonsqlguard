///|
fn main {
  let hits = @sqlg.scan_fields([
    { name: "user", value: b"alice" },
    { name: "q", value: b"1 OR 1=1" },
    { name: "ua", value: b"Mozilla/5.0" },
    { name: "id", value: b"1--" },
  ])
  println("hits " + hits.length().to_string())
  for h in hits {
    println(h.name + " " + @sqlg.format_detection(h.detection))
  }
}
