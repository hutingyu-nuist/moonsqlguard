from pathlib import Path

def parse_file(path: Path):
    text = path.read_bytes().replace(b"\r\n", b"\n")
    acc = {"test": bytearray(), "input": bytearray(), "expected": bytearray()}
    buf = None
    for line in text.split(b"\n"):
        if line == b"--TEST--":
            buf = "test"
            continue
        if line == b"--INPUT--":
            buf = "input"
            continue
        if line == b"--EXPECTED--":
            buf = "expected"
            continue
        if buf is not None:
            acc[buf] += line + b"\n"

    def rtrim(b: bytes) -> bytes:
        while b and b[-1] in b" \n\t\r":
            b = b[:-1]
        return b

    return rtrim(bytes(acc["input"])), rtrim(bytes(acc["expected"]))


def mbt_escape_bytes(data: bytes) -> str:
    out = ['b"']
    for b in data:
        if b == 92:
            out.append("\\\\")
        elif b == 34:
            out.append('\\"')
        elif b == 10:
            out.append("\\n")
        elif b == 13:
            out.append("\\r")
        elif b == 9:
            out.append("\\t")
        elif 32 <= b <= 126:
            out.append(chr(b))
        else:
            out.append("\\x{:02x}".format(b))
    out.append('"')
    return "".join(out)


def mbt_escape_string(data: bytes) -> str:
    out = ['"']
    text = data.decode("latin1")
    for ch in text:
        o = ord(ch)
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\r":
            out.append("\\r")
        elif ch == "\t":
            out.append("\\t")
        elif 32 <= o <= 126:
            out.append(ch)
        else:
            out.append("\\u{{{:x}}}".format(o))
    out.append('"')
    return "".join(out)


root = Path(r"C:\Users\42673\Desktop\工作区\随用随清\moonsqlguard-evidence\upstream-full\libinjection-d88a8f86d617ac8dcb9169c9f34637aaac71ac76\tests")
out_dir = Path(r"C:\Users\42673\Desktop\工作区\随用随清\moonsqlguard")
tools = Path(r"C:\Users\42673\Desktop\工作区\随用随清\moonsqlguard\tools")

sqli = sorted(root.glob("test-sqli-*.txt"))
folding = sorted(root.glob("test-folding-*.txt"))
tokens = sorted(root.glob("test-tokens-*.txt"))

lines = [
    "// Generated from libinjection tests at d88a8f86d617ac8dcb9169c9f34637aaac71ac76.",
    "// Do not edit by hand; tools/generate_fixtures.py",
    "",
    "///|",
    "struct Fixture {",
    "  name : String",
    "  input : Bytes",
    "  expected : String",
    "} derive(Eq, Debug)",
    "",
    "///|",
    "
def emit_array(name: str, files):
    rows = ["///|", "let {} : Array[Fixture] = [".format(name)]
    for path in files:
        inp, exp = parse_file(path)
        rows.append(
            "  {{ name: {}, input: {}, expected: {} }},".format(
                mbt_escape_string(path.name.encode("ascii")),
                mbt_escape_bytes(inp),
                mbt_escape_string(exp),
            )
        )
    rows.append("]")
    rows.append("")
    return rows, len(files)

a, n1 = emit_array("sqli_fixtures", sqli)
b, n2 = emit_array("folding_fixtures", folding)
# Keep a representative tokenizer subset plus a few hard cases rather than 249 files.
token_keep = [p for p in tokens if any(key in p.name for key in (
    "061", "062", "backquotes", "comment", "number", "string", "operator", "var", "dollar", "mysql"
))]
if len(token_keep) < 40:
    token_keep = tokens[:60]
c, n3 = emit_array("token_fixtures", token_keep)
body = "\n".join(lines + a + b + c) + "\n"
(out_dir / "fixtures_data_wbtest.mbt").write_text(body, encoding="utf-8")
print("sqli", n1, "folding", n2, "tokens", n3, "bytes", len(body))


