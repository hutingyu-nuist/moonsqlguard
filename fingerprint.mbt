///|
/// Folded tokens and lexer statistics for one explicit parsing context.
pub(all) struct Fingerprint {
  pattern : String
  tokens : Array[Token]
  consumed_tokens : Int
  ambiguous_comments : Int
  hashes : Int
} derive(Eq, Debug)

///|
pub extend Fingerprint with Eq::{not_equal, equal}

///|
pub extend Fingerprint with @debug.Debug::{to_repr}

///|
/// Run the upstream bounded folding algorithm in one quote/dialect context.
pub fn fingerprint(
  data : Bytes,
  dialect? : Dialect = Ansi,
  quote? : Quote = None,
) -> Fingerprint {
  let sf = scanner(data, dialect, quote)
  let vec = Array::makei(8, _ => token("", 0, b""))
  let n = fold_engine(sf, vec)
  if n > 2 &&
    vec[n - 1].kind == "n" &&
    vec[n - 1].open == 96 &&
    vec[n - 1].value.length() == 0 &&
    vec[n - 1].close == 0 {
    vec[n - 1].kind = "c"
  }
  let tokens = Array::makei(n, i => vec[i].duplicate())
  let s = StringBuilder()
  for t in tokens {
    s.write_string(t.kind)
  }
  let pattern = s.to_string()
  if pattern.contains("X") {
    {
      pattern: "X",
      tokens: [token("X", vec[0].pos, b"X")],
      consumed_tokens: sf.tokens,
      ambiguous_comments: sf.dash_ambiguous,
      hashes: sf.hash_count,
    }
  } else {
    {
      pattern,
      tokens,
      consumed_tokens: sf.tokens,
      ambiguous_comments: sf.dash_ambiguous,
      hashes: sf.hash_count,
    }
  }
}
