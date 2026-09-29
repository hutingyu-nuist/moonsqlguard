///|
/// A named request field or log column presented to the detector.
pub(all) struct Field {
  name : String
  value : Bytes
} derive(Eq, Debug)

///|
pub extend Field with Eq::{not_equal, equal}

///|
pub extend Field with @debug.Debug::{to_repr}

///|
/// A field whose bytes were classified as SQLi.
pub(all) struct FieldHit {
  name : String
  detection : Detection
} derive(Eq, Debug)

///|
pub extend FieldHit with Eq::{not_equal, equal}

///|
pub extend FieldHit with @debug.Debug::{to_repr}

///|
/// Inspect each field in order and keep only SQLi hits.
pub fn scan_fields(fields : Array[Field]) -> Array[FieldHit] {
  let out : Array[FieldHit] = []
  for f in fields {
    let detection = inspect(f.value)
    if detection.hit {
      out.push({ name: f.name, detection, })
    }
  }
  out
}

///|
/// Format a verdict for logs: `sqli <pattern>` or `clean <pattern>`.
pub fn format_detection(d : Detection) -> String {
  let s = StringBuilder()
  if d.hit {
    s.write_string("sqli ")
  } else {
    s.write_string("clean ")
  }
  s.write_string(d.pattern)
  s.to_string()
}
