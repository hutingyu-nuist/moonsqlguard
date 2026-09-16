// Generated from libinjection tests at d88a8f86d617ac8dcb9169c9f34637aaac71ac76.
// Do not edit by hand; tools/generate_fixtures.py

///|
struct Fixture {
  name : String
  input : Bytes
  expected : String
} derive(Eq, Debug)

///|
let sqli_fixtures : Array[Fixture] = [
  { name: "test-sqli-001.txt", input: b"foo 'bar' \"zap\"", expected: "" },
  { name: "test-sqli-002.txt", input: b"foo 'bar'", expected: "" },
  { name: "test-sqli-003.txt", input: b"foo 'bar'", expected: "" },
  { name: "test-sqli-004.txt", input: b"1 = 1 OR 1", expected: "1&1" },
  { name: "test-sqli-005.txt", input: b"1 = '1' OR 1", expected: "1os&1" },
  { name: "test-sqli-006.txt", input: b"1 = \"1\" OR 1", expected: "1os&1" },
  { name: "test-sqli-007.txt", input: b"1 /* /* */ */ 2", expected: "X" },
  {
    name: "test-sqli-008.txt",
    input: b"1 = \"1\" /* 'blah' */  OR 1",
    expected: "1os&1",
  },
  {
    name: "test-sqli-009.txt",
    input: b"1 = '1' /* \"blah\" */  OR 1",
    expected: "1os&1",
  },
  { name: "test-sqli-010.txt", input: b"1# blah blah", expected: "" },
  { name: "test-sqli-011.txt", input: b"foo--", expected: "" },
  {
    name: "test-sqli-012.txt",
    input: b"foo/* yes this is sqli */",
    expected: "nc",
  },
  {
    name: "test-sqli-013.txt",
    input: b"1/* yes this is sqli */",
    expected: "1c",
  },
  { name: "test-sqli-014.txt", input: b"1--", expected: "1c" },
  { name: "test-sqli-015.txt", input: b"\"foo\" OR \"BAR\"", expected: "" },
  { name: "test-sqli-016.txt", input: b"foo\" OR \"BAR\"", expected: "" },
  { name: "test-sqli-017.txt", input: b"\"foo\" OR \"BAR", expected: "" },
  { name: "test-sqli-018.txt", input: b"foo' OR \"BAR", expected: "" },
  { name: "test-sqli-019.txt", input: b"foo' OR 'BAR", expected: "s&s" },
  { name: "test-sqli-020.txt", input: b"foo' + 1", expected: "" },
  { name: "test-sqli-021.txt", input: b"'foo' + 1", expected: "" },
  {
    name: "test-sqli-022.txt",
    input: b"1\" UNION ALL SELECT * FROM FOO",
    expected: "sUEok",
  },
  { name: "test-sqli-023.txt", input: b"1\" INCH", expected: "" },
  { name: "test-sqli-024.txt", input: b"1' INCH", expected: "" },
  {
    name: "test-sqli-025.txt",
    input: b"--1 UNION ALL SELECT * FROM FOO",
    expected: "1UEok",
  },
  { name: "test-sqli-026.txt", input: b"1' == --1 OR 1", expected: "so1&1" },
  {
    name: "test-sqli-027.txt",
    input: b"1\" UNION ALL SELECT --1 FROM FOO",
    expected: "sUE1k",
  },
  { name: "test-sqli-028.txt", input: b"foo'--'bar'", expected: "" },
  { name: "test-sqli-029.txt", input: b"--blah", expected: "" },
  { name: "test-sqli-030.txt", input: b"1--sp_password", expected: "1c" },
  { name: "test-sqli-031.txt", input: b"x'--sp_password", expected: "sc" },
  { name: "test-sqli-032.txt", input: b"1*1--", expected: "1c" },
  { name: "test-sqli-033.txt", input: b"1 /*!anything*/", expected: "X" },
  {
    name: "test-sqli-034.txt",
    input: b"1--0000000000111111111122222222223333333333 sp_password",
    expected: "1c",
  },
  { name: "test-sqli-035.txt", input: b"", expected: "" },
  { name: "test-sqli-036.txt", input: b"foo\" and 1=1 `", expected: "s&1c" },
  { name: "test-sqli-037.txt", input: b"foo\" and 1=1 `", expected: "s&1c" },
  { name: "test-sqli-038.txt", input: b"1 and @version", expected: "" },
  { name: "test-sqli-039.txt", input: b"1 and @version < 1", expected: "1&v" },
  {
    name: "test-sqli-040.txt",
    input: b"1 and \"a\" < \"b\"",
    expected: "1&sos",
  },
  { name: "test-sqli-041.txt", input: b"1 and \"a\"", expected: "" },
  { name: "test-sqli-042.txt", input: b"1 TOP 'foo'", expected: "" },
  { name: "test-sqli-043.txt", input: b"1 UNION", expected: "" },
  { name: "test-sqli-044.txt", input: b"1 ANALYZE 'foo'", expected: "" },
  { name: "test-sqli-045.txt", input: b"1 /* junk */ UNION", expected: "1U" },
  {
    name: "test-sqli-046.txt",
    input: b"1),(1)) UNION SELECT 1;",
    expected: "1)UE1",
  },
  {
    name: "test-sqli-047.txt",
    input: b"foo - (bar) UNION SELECT 1",
    expected: "nUE1",
  },
  {
    name: "test-sqli-048.txt",
    input: b"foo - (1) UNION SELECT 1",
    expected: "nUE1",
  },
  {
    name: "test-sqli-049.txt",
    input: b"1, -sin(1)) UNION SELECT 1",
    expected: "1,f(1",
  },
  {
    name: "test-sqli-050.txt",
    input: b"{``.``.id} UNION SELECT table_name from information_schemas LIMIT 1",
    expected: "X",
  },
]

///|
let folding_fixtures : Array[Fixture] = [
  {
    name: "test-folding-001.txt",
    input: b"SELECT \"first\" \"second\";",
    expected: "E SELECT\ns \"first\"\n; ;",
  },
  {
    name: "test-folding-002.txt",
    input: b"- SELECT 1;",
    expected: "E SELECT\n1 1\n; ;",
  },
  {
    name: "test-folding-003.txt",
    input: b"( SELECT 1 );",
    expected: "E SELECT\n1 1\n) )\n; ;",
  },
  {
    name: "test-folding-004.txt",
    input: b"-( - SELECT 1 );",
    expected: "E SELECT\n1 1\n) )\n; ;",
  },
  {
    name: "test-folding-005.txt",
    input: b"/* foo */ SELECT 1 );",
    expected: "E SELECT\n1 1\n) )\n; ;",
  },
  {
    name: "test-folding-006.txt",
    input: b"- /* foo */ ( /* bar */ -SELECT 1 );",
    expected: "E SELECT\n1 1\n) )\n; ;",
  },
  {
    name: "test-folding-007.txt",
    input: b"- /* foo */ ( /* bar */ -",
    expected: "",
  },
  { name: "test-folding-008.txt", input: b"123", expected: "1 123" },
  { name: "test-folding-009.txt", input: b"123;", expected: "1 123\n; ;" },
  {
    name: "test-folding-010.txt",
    input: b"123 /* junk */;",
    expected: "1 123\n; ;",
  },
  {
    name: "test-folding-011.txt",
    input: b"123; /* junk */",
    expected: "1 123\n; ;\nc /* junk */",
  },
  { name: "test-folding-012.txt", input: b"-1", expected: "1 1" },
  { name: "test-folding-013.txt", input: b"1+-1", expected: "1 1" },
  { name: "test-folding-014.txt", input: b"1+-+1", expected: "1 1" },
  { name: "test-folding-015.txt", input: b"1+(-1)", expected: "1 1" },
  { name: "test-folding-016.txt", input: b"1 + foo", expected: "1 1" },
  { name: "test-folding-017.txt", input: b"foo + 1", expected: "n foo" },
  {
    name: "test-folding-018.txt",
    input: b"foo OR zap AND bar",
    expected: "n foo\n& OR\nn bar",
  },
  { name: "test-folding-019.txt", input: b"1+(-(1))", expected: "1 1\n) )" },
  { name: "test-folding-020.txt", input: b"1 + foo + 1", expected: "1 1" },
  { name: "test-folding-021.txt", input: b"`foo`.`bar`", expected: "n foo" },
  {
    name: "test-folding-022.txt",
    input: b"'foo' + zap + 'bar'",
    expected: "s 'foo'\no +\ns 'bar'",
  },
  {
    name: "test-folding-023.txt",
    input: b"foo zap bar",
    expected: "n foo\nn zap\nn bar",
  },
  { name: "test-folding-024.txt", input: b"", expected: "" },
  { name: "test-folding-025.txt", input: b"UNION", expected: "U UNION" },
  { name: "test-folding-026.txt", input: b"UNION ALL", expected: "U UNION ALL" },
  {
    name: "test-folding-027.txt",
    input: b"UNION /* foo */ALL",
    expected: "U UNION ALL",
  },
  { name: "test-folding-028.txt", input: b"", expected: "" },
  {
    name: "test-folding-029.txt",
    input: b"select - 1;",
    expected: "E select\n1 1\n; ;",
  },
  {
    name: "test-folding-030.txt",
    input: b"select + 1;",
    expected: "E select\n1 1\n; ;",
  },
  {
    name: "test-folding-031.txt",
    input: b"select ~ 1;",
    expected: "E select\n1 1\n; ;",
  },
  {
    name: "test-folding-032.txt",
    input: b"select !! 1;",
    expected: "E select\n1 1\n; ;",
  },
  {
    name: "test-folding-033.txt",
    input: b"select - @version;",
    expected: "E select\nv @version\n; ;",
  },
  {
    name: "test-folding-034.txt",
    input: b"select - 'astring';",
    expected: "E select\ns 'astring'\n; ;",
  },
  {
    name: "test-folding-035.txt",
    input: b"select - sin(1);",
    expected: "E select\nf sin\n( (\n1 1\n) )",
  },
  {
    name: "test-folding-036.txt",
    input: b"select - foobar;",
    expected: "E select\nn foobar\n; ;",
  },
  {
    name: "test-folding-037.txt",
    input: b"select - foobar;",
    expected: "E select\nn foobar\n; ;",
  },
  {
    name: "test-folding-038.txt",
    input: b"select user;",
    expected: "E select\nn user\n; ;",
  },
  {
    name: "test-folding-039.txt",
    input: b"select user();",
    expected: "E select\nf user\n( (\n) )\n; ;",
  },
  {
    name: "test-folding-040.txt",
    input: b"select password;",
    expected: "E select\nn password\n; ;",
  },
  {
    name: "test-folding-041.txt",
    input: b"select password();",
    expected: "E select\nf password\n( (\n) )\n; ;",
  },
  {
    name: "test-folding-042.txt",
    input: b"select database;",
    expected: "E select\nn database\n; ;",
  },
  {
    name: "test-folding-043.txt",
    input: b"select database();",
    expected: "E select\nf database\n( (\n) )\n; ;",
  },
  {
    name: "test-folding-044.txt",
    input: b"select foobar();",
    expected: "E select\nn foobar\n( (\n) )\n; ;",
  },
  {
    name: "test-folding-045.txt",
    input: b"select if 1;",
    expected: "E select\nf if\n1 1\n; ;",
  },
  {
    name: "test-folding-046.txt",
    input: b"select if(1)",
    expected: "E select\nf if\n( (\n1 1\n) )",
  },
  { name: "test-folding-047.txt", input: b"foo & foo", expected: "n foo" },
  {
    name: "test-folding-048.txt",
    input: b"foo foo & foo",
    expected: "n foo\nn foo",
  },
  {
    name: "test-folding-049.txt",
    input: b"SELECT double precision '1';",
    expected: "E SELECT\ns '1'\n; ;",
  },
  {
    name: "test-folding-050.txt",
    input: b"SELECT character varying '1';",
    expected: "E SELECT\ns '1'\n; ;",
  },
  {
    name: "test-folding-051.txt",
    input: b"SELECT '1'::money, 2;",
    expected: "E SELECT\ns '1'\n; ;",
  },
  {
    name: "test-folding-052.txt",
    input: b"SELECT float 1;",
    expected: "E SELECT\n1 1\n; ;",
  },
  {
    name: "test-folding-053.txt",
    input: b"SELECT float @@version;",
    expected: "E SELECT\nv @@version\n; ;",
  },
  {
    name: "test-folding-054.txt",
    input: b"1 float before",
    expected: "1 1\nt float\nk before",
  },
  { name: "test-folding-055.txt", input: b"float junk", expected: "n junk" },
  {
    name: "test-folding-056.txt",
    input: b"1 and 2 not between 3",
    expected: "1 1\n& and\n1 2",
  },
  {
    name: "test-folding-057.txt",
    input: b"select current_user;",
    expected: "E select\nv current_user\n; ;",
  },
  {
    name: "test-folding-058.txt",
    input: b"select current_user();",
    expected: "E select\nf current_user\n( (\n) )\n; ;",
  },
  {
    name: "test-folding-059.txt",
    input: b"select 1 AND -2 + 3;",
    expected: "E select\n1 1\n& AND\n1 2\n; ;",
  },
  {
    name: "test-folding-060.txt",
    input: b"select +++ (1);",
    expected: "E select\n( (\n1 1\n) )\n; ;",
  },
  {
    name: "test-folding-061.txt",
    input: b"select 1 / (2,3,4);",
    expected: "E select\n1 1\no /\n( (\n1 2",
  },
  {
    name: "test-folding-062.txt",
    input: b"select 1 IN (2,3,4);",
    expected: "E select\n1 1\no IN\n( (\n1 2",
  },
  {
    name: "test-folding-063.txt",
    input: b"select 1 not IN (2,3,4);",
    expected: "E select\n1 1\no not IN\n( (\n1 2",
  },
  {
    name: "test-folding-064.txt",
    input: b"1 group by -(2)",
    expected: "1 1\nB group by\n( (\n1 2\n) )",
  },
  {
    name: "test-folding-065.txt",
    input: b"1 group by -2",
    expected: "1 1\nB group by\n1 2",
  },
  {
    name: "test-folding-066.txt",
    input: b"1; /* foo */; select 2;",
    expected: "1 1\n; ;\nE select\n1 2\n; ;",
  },
  {
    name: "test-folding-067.txt",
    input: b"1 UNION DISTINCT 1;",
    expected: "1 1\nU UNION DISTINCT\n1 1\n; ;",
  },
  {
    name: "test-folding-068.txt",
    input: b"1 UNION ALL DISTINCT 1;",
    expected: "1 1\nU UNION ALL DISTINCT\n1 1\n; ;",
  },
  {
    name: "test-folding-069.txt",
    input: b"1 UNION DISTINCT ALL 1;",
    expected: "1 1\nU UNION DISTINCT ALL\n1 1\n; ;",
  },
  {
    name: "test-folding-070.txt",
    input: b"select 1,-(2);",
    expected: "E select\n1 1\n, ,\n( (\n1 2",
  },
  {
    name: "test-folding-071.txt",
    input: b"select 1,-1;",
    expected: "E select\n1 1\n; ;",
  },
  {
    name: "test-folding-072.txt",
    input: b"1;if 1=1",
    expected: "1 1\n; ;\nT if\n1 1",
  },
  { name: "test-folding-073.txt", input: b"foo,bar", expected: "n foo" },
  {
    name: "test-folding-074.txt",
    input: b"SELECT 1 + binary 1;",
    expected: "E SELECT\n1 1\n; ;",
  },
  {
    name: "test-folding-075.txt",
    input: b"SELECT 1 + binary 2 + 3;",
    expected: "E SELECT\n1 1\n; ;",
  },
  {
    name: "test-folding-076.txt",
    input: b"SELECT \\%0;",
    expected: "E SELECT\n1 \\\n; ;",
  },
  {
    name: "test-folding-077.txt",
    input: b"SELECT \\ % 0 ;",
    expected: "E SELECT\n1 \\\n; ;",
  },
  {
    name: "test-folding-078.txt",
    input: b"SELECT \\1;",
    expected: "E SELECT\n1 1\n; ;",
  },
  {
    name: "test-folding-079.txt",
    input: b"SELECT 1 COLLATE papers;",
    expected: "E SELECT\n1 1\nA COLLATE\nn papers\n; ;",
  },
  {
    name: "test-folding-080.txt",
    input: b"SELECT 1 COLLATE LATIN1_GERMAN2_CI;",
    expected: "E SELECT\n1 1\nA COLLATE\nt LATIN1_GERMAN2_CI\n; ;",
  },
  { name: "test-folding-081.txt", input: b"1 mod (2)", expected: "1 1" },
  {
    name: "test-folding-082.txt",
    input: b"@version mod (2)",
    expected: "v @version\no mod\n( (\n1 2\n) )",
  },
  {
    name: "test-folding-083.txt",
    input: b"@version + @version",
    expected: "v @version",
  },
  {
    name: "test-folding-084.txt",
    input: b"@version + 1",
    expected: "v @version",
  },
  {
    name: "test-folding-085.txt",
    input: b"@version + foo",
    expected: "v @version",
  },
  {
    name: "test-folding-086.txt",
    input: b"1))+1",
    expected: "1 1\n) )\no +\n1 1",
  },
  {
    name: "test-folding-087.txt",
    input: b"1))))))))))))))+1",
    expected: "1 1\n) )\no +\n1 1",
  },
  { name: "test-folding-088.txt", input: b"1 + NOT 1", expected: "1 1" },
  { name: "test-folding-089.txt", input: b"1,-1", expected: "1 1" },
  { name: "test-folding-090.txt", input: b"1,-junk", expected: "1 1" },
  { name: "test-folding-091.txt", input: b"1,-@version", expected: "1 1" },
  { name: "test-folding-092.txt", input: b"1,-\"foo\"", expected: "1 1" },
  {
    name: "test-folding-093.txt",
    input: b"IN YOUR FACE",
    expected: "n IN\nn YOUR\nn FACE",
  },
  {
    name: "test-folding-094.txt",
    input: b"select {foo 1};",
    expected: "E select\n1 1\n; ;",
  },
  {
    name: "test-folding-095.txt",
    input: b"IF EXISTS(1)",
    expected: "f IF EXISTS\n( (\n1 1\n) )",
  },
  {
    name: "test-folding-096.txt",
    input: b"IF EXISTS(1)",
    expected: "f IF EXISTS\n( (\n1 1\n) )",
  },
  {
    name: "test-folding-097.txt",
    input: b"IF NOT EXISTS(1)",
    expected: "f IF NOT EXISTS\n( (\n1 1\n) )",
  },
  { name: "test-folding-098.txt", input: b"foo . `bar`", expected: "n foo" },
  {
    name: "test-folding-099.txt",
    input: b"SELECT 1.e.table_name",
    expected: "E SELECT\nn table_name",
  },
  {
    name: "test-folding-100.txt",
    input: b"SELECT 10.e.`table_name`",
    expected: "E SELECT\nn table_name",
  },
  {
    name: "test-folding-101.txt",
    input: b"SELECT . `foo`",
    expected: "E SELECT\nn foo",
  },
  {
    name: "test-folding-102.txt",
    input: b"SELECT AAAAAAAAAABBBBBBBBBBCCCCCCCCCC AAAAAAAAAABBBBBBBBBBCCCCCCCCCC",
    expected: "E SELECT\nn AAAAAAAAAABBBBBBBBBBCCCCCCCCCC\nn AAAAAAAAAABBBBBBBBBBCCCCCCCCCC",
  },
  {
    name: "test-folding-103.txt",
    input: b"SELECT AAAAAAAAAABBBBBBBBBBCCCCCCCCCC AAAAAAAAAABBBBBBBBBBCCCCCCCCCC",
    expected: "E SELECT\nn AAAAAAAAAABBBBBBBBBBCCCCCCCCCC\nn AAAAAAAAAABBBBBBBBBBCCCCCCCCCC",
  },
  { name: "test-folding-104.txt", input: b"1 - (1 - 1)", expected: "1 1" },
  { name: "test-folding-105.txt", input: b"1 - (1 - 1) + 2", expected: "1 1" },
  {
    name: "test-folding-106.txt",
    input: b"1 - (1 - 1) --",
    expected: "1 1\nc --",
  },
  {
    name: "test-folding-107.txt",
    input: b"1-(1-1)-2 --",
    expected: "1 1\nc --",
  },
  {
    name: "test-folding-108.txt",
    input: b"SELECT (BINARY BINARY 1);",
    expected: "E SELECT\n( (\n1 1\n) )\n; ;",
  },
  { name: "test-folding-109.txt", input: b"1 - binary ( 2 )", expected: "1 1" },
  {
    name: "test-folding-110.txt",
    input: b"1 - binary binary 2",
    expected: "1 1",
  },
  {
    name: "test-folding-111.txt",
    input: b"1 - binary binary (2)",
    expected: "1 1",
  },
  {
    name: "test-folding-112.txt",
    input: b"1 - (binary binary (2))",
    expected: "1 1\n) )",
  },
  {
    name: "test-folding-113.txt",
    input: b"SELECT LIKE(\"foo\",\"bar\")",
    expected: "E SELECT\nf LIKE\n( (\ns \"foo\"\n) )",
  },
  {
    name: "test-folding-114.txt",
    input: b"SELECT NOT LIKE(\"foo\",\"bar\")",
    expected: "E SELECT\nf NOT LIKE\n( (\ns \"foo\"\n) )",
  },
  {
    name: "test-folding-115.txt",
    input: b"{``.``.id} UNION SELECT TABLE",
    expected: "{ {\nX",
  },
  {
    name: "test-folding-116.txt",
    input: b"1 USER(1)",
    expected: "1 1\nn USER\n( (\n1 1\n) )",
  },
  {
    name: "test-folding-117.txt",
    input: b"1 USER()",
    expected: "1 1\nf USER\n( (\n) )",
  },
  {
    name: "test-folding-118.txt",
    input: b"; if not((select serverproperty('isintegratedsecurityonly'))",
    expected: "; ;\nT if not\n( (\nE select\nf serverproperty",
  },
]

///|
let token_fixtures : Array[Fixture] = [
  {
    name: "test-tokens-061.txt",
    input: b"select 1,'''',2;",
    expected: "E select\n1 1\n, ,\ns ''''\n, ,\n1 2\n; ;",
  },
  {
    name: "test-tokens-062.txt",
    input: b"select 1,'\\\\\\\\',2;",
    expected: "E select\n1 1\n, ,\ns '\\\\\\\\'\n, ,\n1 2\n; ;",
  },
  {
    name: "test-tokens-backquotes-001.txt",
    input: b"SELECT `version`();",
    expected: "E SELECT\nf version\n( (\n) )\n; ;",
  },
  {
    name: "test-tokens-backquotes-002.txt",
    input: b"SELECT `select`;",
    expected: "E SELECT\nn select\n; ;",
  },
  {
    name: "test-tokens-backquotes-003.txt",
    input: b"SELECT foo.`select`;",
    expected: "E SELECT\nn foo.`select`\n; ;",
  },
  {
    name: "test-tokens-backquotes-004.txt",
    input: b"SELECT `foo`.`bar`;",
    expected: "E SELECT\nn foo\n. .\nn bar\n; ;",
  },
  {
    name: "test-tokens-backquotes-005.txt",
    input: b"SELECT `foo`.bar;",
    expected: "E SELECT\nn foo\n. .\nn bar\n; ;",
  },
  {
    name: "test-tokens-backquotes-006.txt",
    input: b"SELECT @@`version`;",
    expected: "E SELECT\nv @@`version`\n; ;",
  },
  {
    name: "test-tokens-backquotes-007.txt",
    input: b"SELECT @`version`;",
    expected: "E SELECT\nv @`version`\n; ;",
  },
  {
    name: "test-tokens-backquotes-008.txt",
    input: b"SELECT @`foo``bar`;",
    expected: "E SELECT\nv @`foo``bar`\n; ;",
  },
  {
    name: "test-tokens-backquotes-009.txt",
    input: b"SELECT @`foobar`",
    expected: "E SELECT\nv @`foobar`",
  },
  {
    name: "test-tokens-backquotes-010.txt",
    input: b"SELECT @`foobar",
    expected: "E SELECT\nv @`foobar",
  },
  {
    name: "test-tokens-backquotes-011.txt",
    input: b"SELECT @`foobar``",
    expected: "E SELECT\nv @`foobar``",
  },
  {
    name: "test-tokens-backquotes-012.txt",
    input: b"SELECT`foobar`",
    expected: "E SELECT\nn foobar",
  },
  {
    name: "test-tokens-comments-cstyle-001.txt",
    input: b"SELECT 1 /* 2 */;",
    expected: "E SELECT\n1 1\nc /* 2 */\n; ;",
  },
  {
    name: "test-tokens-comments-cstyle-002.txt",
    input: b"SELECT 1 /* 2",
    expected: "E SELECT\n1 1\nc /* 2",
  },
  {
    name: "test-tokens-comments-cstyle-003.txt",
    input: b"SELECT 1 /* 2 */",
    expected: "E SELECT\n1 1\nc /* 2 */",
  },
  {
    name: "test-tokens-comments-cstyle-004.txt",
    input: b"SELECT 1 /*",
    expected: "E SELECT\n1 1\nc /*",
  },
  {
    name: "test-tokens-comments-cstyle-005.txt",
    input: b"SELECT 1 /",
    expected: "E SELECT\n1 1\no /",
  },
  {
    name: "test-tokens-comments-cstyle-006.txt",
    input: b"/* foo **/1",
    expected: "c /* foo **/\n1 1",
  },
  {
    name: "test-tokens-comments-cstylenested-001.txt",
    input: b"SELECT /* FOO /* BAR */ JUNK */",
    expected: "E SELECT\nX /* FOO /* BAR */\nn JUNK\no *\no /",
  },
  {
    name: "test-tokens-comments-cstylenested-002.txt",
    input: b"SELECT /* FOO /*/ BAR */",
    expected: "E SELECT\nX /* FOO /*/\nn BAR\no *\no /",
  },
  {
    name: "test-tokens-comments-ddash-001.txt",
    input: b"SELECT 1 --",
    expected: "E SELECT\n1 1\nc --",
  },
  {
    name: "test-tokens-comments-ddash-002.txt",
    input: b"SELECT 1 --sp_password",
    expected: "E SELECT\n1 1\nc --sp_password",
  },
  {
    name: "test-tokens-comments-ddash-003.txt",
    input: b"SELECT 1 -- ABCD\n;",
    expected: "E SELECT\n1 1\nc -- ABCD\n; ;",
  },
  {
    name: "test-tokens-comments-ddash-004.txt",
    input: b"SELECT 1 -- ABCD",
    expected: "E SELECT\n1 1\nc -- ABCD",
  },
  {
    name: "test-tokens-comments-ddash-005.txt",
    input: b"SELECT 1 -",
    expected: "E SELECT\n1 1\no -",
  },
  {
    name: "test-tokens-comments-mysql-001.txt",
    input: b"SELECT 1 /*! 2 */;",
    expected: "E SELECT\n1 1\nX /*! 2 */\n; ;",
  },
  {
    name: "test-tokens-comments-mysql-002.txt",
    input: b"SELECT 1 /*! ,2 */;",
    expected: "E SELECT\n1 1\nX /*! ,2 */\n; ;",
  },
  {
    name: "test-tokens-comments-mysql-006.txt",
    input: b"SELECT 1 /*!00,2",
    expected: "E SELECT\n1 1\nX /*!00,2",
  },
  {
    name: "test-tokens-comments-mysql-007.txt",
    input: b"SELECT 1 /*!",
    expected: "E SELECT\n1 1\nX /*!",
  },
  {
    name: "test-tokens-comments-mysql-009.txt",
    input: b"SELECT 1 /*!123",
    expected: "E SELECT\n1 1\nX /*!123",
  },
  {
    name: "test-tokens-comments-mysql-010.txt",
    input: b"SELECT 1 /*!12XXXXXXXXXXXX",
    expected: "E SELECT\n1 1\nX /*!12XXXXXXXXXXXX",
  },
  {
    name: "test-tokens-comments-mysql-011.txt",
    input: b"SELECT 1 /*!*/;",
    expected: "E SELECT\n1 1\nX /*!*/\n; ;",
  },
  {
    name: "test-tokens-numbers-binary-001.txt",
    input: b"SELECT 0b0101010;",
    expected: "E SELECT\n1 0b0101010\n; ;",
  },
  {
    name: "test-tokens-numbers-binary-002.txt",
    input: b"SELECT 0B0101010;",
    expected: "E SELECT\n1 0B0101010\n; ;",
  },
  {
    name: "test-tokens-numbers-binary-003.txt",
    input: b"SELECT 0b;",
    expected: "E SELECT\nn 0b\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-001.txt",
    input: b"SELECT 1E;",
    expected: "E SELECT\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-002.txt",
    input: b"SELECT 1E2;",
    expected: "E SELECT\n1 1E2\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-003.txt",
    input: b"SELECT 1.2E34;",
    expected: "E SELECT\n1 1.2E34\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-004.txt",
    input: b"SELECT 1E+10;",
    expected: "E SELECT\n1 1E+10\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-005.txt",
    input: b"SELECT 1E-10;",
    expected: "E SELECT\n1 1E-10\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-006.txt",
    input: b"SELECT .123e1;",
    expected: "E SELECT\n1 .123e1\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-007.txt",
    input: b"SELECT .123e+1;",
    expected: "E SELECT\n1 .123e+1\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-008.txt",
    input: b"SELECT .123e-1;",
    expected: "E SELECT\n1 .123e-1\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-009.txt",
    input: b"SELECT 123E",
    expected: "E SELECT",
  },
  {
    name: "test-tokens-numbers-exp-010.txt",
    input: b"SELECT 123E+",
    expected: "E SELECT",
  },
  {
    name: "test-tokens-numbers-exp-011.txt",
    input: b"SELECT 10.e;",
    expected: "E SELECT\n; ;",
  },
  {
    name: "test-tokens-numbers-exp-012.txt",
    input: b"SELECT 10.10e;",
    expected: "E SELECT\n; ;",
  },
  {
    name: "test-tokens-numbers-floats-001.txt",
    input: b"SELECT 1.",
    expected: "E SELECT\n1 1.",
  },
  {
    name: "test-tokens-numbers-floats-002.txt",
    input: b"SELECT 1.;",
    expected: "E SELECT\n1 1.\n; ;",
  },
  {
    name: "test-tokens-numbers-floats-003.txt",
    input: b"SELECT .0;",
    expected: "E SELECT\n1 .0\n; ;",
  },
  {
    name: "test-tokens-numbers-floats-004.txt",
    input: b"SELECT 123456789.12345678912345678 + 1;",
    expected: "E SELECT\n1 123456789.12345678912345678\no +\n1 1\n; ;",
  },
  {
    name: "test-tokens-numbers-floats-005.txt",
    input: b"SELECT .23456789;",
    expected: "E SELECT\n1 .23456789\n; ;",
  },
  {
    name: "test-tokens-numbers-floats-006.txt",
    input: b"SELECT .;",
    expected: "E SELECT\n. .\n; ;",
  },
  {
    name: "test-tokens-numbers-hex-001.txt",
    input: b"SELECT 0xFF;",
    expected: "E SELECT\n1 0xFF\n; ;",
  },
  {
    name: "test-tokens-numbers-hex-002.txt",
    input: b"SELECT 0X0123456789ABCDEF;",
    expected: "E SELECT\n1 0X0123456789ABCDEF\n; ;",
  },
  {
    name: "test-tokens-numbers-hex-003.txt",
    input: b"SELECT 0X;",
    expected: "E SELECT\nn 0X\n; ;",
  },
  {
    name: "test-tokens-numbers-ints-001.txt",
    input: b"SELECT 1",
    expected: "E SELECT\n1 1",
  },
  {
    name: "test-tokens-numbers-ints-002.txt",
    input: b"SELECT +1",
    expected: "E SELECT\no +\n1 1",
  },
  {
    name: "test-tokens-numbers-ints-003.txt",
    input: b"SELECT -1",
    expected: "E SELECT\no -\n1 1",
  },
  {
    name: "test-tokens-numbers-ints-004.txt",
    input: b"SELECT 0;",
    expected: "E SELECT\n1 0\n; ;",
  },
  {
    name: "test-tokens-numbers-ints-005.txt",
    input: b"SELECT (-1);",
    expected: "E SELECT\n( (\no -\n1 1\n) )\n; ;",
  },
  {
    name: "test-tokens-numbers-money-001.txt",
    input: b"SELECT $1",
    expected: "E SELECT\n1 $1",
  },
  {
    name: "test-tokens-numbers-money-002.txt",
    input: b"SELECT $1.00",
    expected: "E SELECT\n1 $1.00",
  },
  {
    name: "test-tokens-numbers-money-003.txt",
    input: b"SELECT $1.00",
    expected: "E SELECT\n1 $1.00",
  },
  {
    name: "test-tokens-numbers-money-004.txt",
    input: b"SELECT $1000.00",
    expected: "E SELECT\n1 $1000.00",
  },
  {
    name: "test-tokens-numbers-money-005.txt",
    input: b"SELECT $.0",
    expected: "E SELECT\n1 $.0",
  },
  {
    name: "test-tokens-numbers-money-006.txt",
    input: b"SELECT $1,000.00",
    expected: "E SELECT\n1 $1,000.00",
  },
  {
    name: "test-tokens-numbers-money-007.txt",
    input: b"SELECT $1.000,00",
    expected: "E SELECT\n1 $1.000,00",
  },
  {
    name: "test-tokens-numbers-money-008.txt",
    input: b"SELECT $",
    expected: "E SELECT\nn $",
  },
  {
    name: "test-tokens-numbers-money-009.txt",
    input: b"SELECT $APPLE",
    expected: "E SELECT\nn $\nn APPLE",
  },
  {
    name: "test-tokens-numbers-money-010.txt",
    input: b"SELECT $.foo;",
    expected: "E SELECT\nn $.foo\n; ;",
  },
  {
    name: "test-tokens-numbers-nan-001.txt",
    input: b"SELECT binary_double_infinity",
    expected: "E SELECT\n1 binary_double_infinity",
  },
  {
    name: "test-tokens-numbers-nan-002.txt",
    input: b"SELECT binary_double_nan",
    expected: "E SELECT\n1 binary_double_nan",
  },
  {
    name: "test-tokens-numbers-nan-003.txt",
    input: b"SELECT binary_float_infinity",
    expected: "E SELECT\n1 binary_float_infinity",
  },
  {
    name: "test-tokens-numbers-nan-004.txt",
    input: b"SELECT binary_float_nan",
    expected: "E SELECT\n1 binary_float_nan",
  },
  {
    name: "test-tokens-numbers-null-001.txt",
    input: b"SELECT NULL;",
    expected: "E SELECT\nv NULL\n; ;",
  },
  {
    name: "test-tokens-numbers-null-002.txt",
    input: b"SELECT \\N;",
    expected: "E SELECT\n1 \\N\n; ;",
  },
  {
    name: "test-tokens-numbers-oracle-001.txt",
    input: b"SELECT 1f;",
    expected: "E SELECT\n1 1f\n; ;",
  },
  {
    name: "test-tokens-numbers-oracle-002.txt",
    input: b"SELECT 1d;",
    expected: "E SELECT\n1 1d\n; ;",
  },
  {
    name: "test-tokens-numbers-oracle-003.txt",
    input: b"SELECT -1.123e+23d;",
    expected: "E SELECT\no -\n1 1.123e+23d\n; ;",
  },
  {
    name: "test-tokens-numbers-oracle-004.txt",
    input: b"SELECT 1f",
    expected: "E SELECT\n1 1f",
  },
  {
    name: "test-tokens-numbers-oracle-005.txt",
    input: b"SELECT 1FROM foo;",
    expected: "E SELECT\n1 1\nk FROM\nn foo\n; ;",
  },
  {
    name: "test-tokens-numbers-oracle-006.txt",
    input: b"SELECT 1Funion select",
    expected: "E SELECT\n1 1F\nU union\nE select",
  },
  {
    name: "test-tokens-numbers-parser-001.txt",
    input: b"SELECT 123UNION",
    expected: "E SELECT\n1 123\nU UNION",
  },
  {
    name: "test-tokens-numbers-parser-002.txt",
    input: b"SELECT 123.UNION",
    expected: "E SELECT\n1 123.\nU UNION",
  },
  {
    name: "test-tokens-numbers-string-001.txt",
    input: b"SELECT x'1234';",
    expected: "E SELECT\n1 x'1234'\n; ;",
  },
  {
    name: "test-tokens-numbers-string-002.txt",
    input: b"SELECT x'';",
    expected: "E SELECT\n1 x''\n; ;",
  },
  {
    name: "test-tokens-numbers-string-003.txt",
    input: b"SELECT x'",
    expected: "E SELECT\nn x\ns '",
  },
  {
    name: "test-tokens-numbers-string-004.txt",
    input: b"SELECT X'1234';",
    expected: "E SELECT\n1 X'1234'\n; ;",
  },
  {
    name: "test-tokens-numbers-string-005.txt",
    input: b"SELECT x\"1234\";",
    expected: "E SELECT\nn x\ns \"1234\"\n; ;",
  },
  {
    name: "test-tokens-numbers-string-006.txt",
    input: b"SELECT b'1010101';",
    expected: "E SELECT\n1 b'1010101'\n; ;",
  },
  {
    name: "test-tokens-numbers-string-007.txt",
    input: b"SELECT B'1010101';",
    expected: "E SELECT\n1 B'1010101'\n; ;",
  },
  {
    name: "test-tokens-numbers-string-008.txt",
    input: b"SELECT b'';",
    expected: "E SELECT\n1 b''\n; ;",
  },
  {
    name: "test-tokens-numbers-string-009.txt",
    input: b"SELECT b'",
    expected: "E SELECT\nn b\ns '",
  },
  {
    name: "test-tokens-numbers-string-010.txt",
    input: b"SELECT b B",
    expected: "E SELECT\nn b\nn B",
  },
  {
    name: "test-tokens-numbers-string-011.txt",
    input: b"SELECT x;",
    expected: "E SELECT\nn x\n; ;",
  },
  {
    name: "test-tokens-numbers-string-012.txt",
    input: b"SELECT x X;",
    expected: "E SELECT\nn x\nn X\n; ;",
  },
  {
    name: "test-tokens-operators-001.txt",
    input: b"SELECT 1 DIV 2;",
    expected: "E SELECT\n1 1\no DIV\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-002.txt",
    input: b"SELECT 1 / 2;",
    expected: "E SELECT\n1 1\no /\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-003.txt",
    input: b"SELECT 1/2;",
    expected: "E SELECT\n1 1\no /\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-004.txt",
    input: b"SELECT 1 |",
    expected: "E SELECT\n1 1\no |",
  },
  {
    name: "test-tokens-operators-005.txt",
    input: b"SELECT 1 | 2;",
    expected: "E SELECT\n1 1\no |\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-006.txt",
    input: b"SELECT 1 || 2;",
    expected: "E SELECT\n1 1\n& ||\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-007.txt",
    input: b"SELECT 1 && 2;",
    expected: "E SELECT\n1 1\n& &&\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-008.txt",
    input: b"SELECT 1 << 2;",
    expected: "E SELECT\n1 1\no <<\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-009.txt",
    input: b"SELECT 1 <= 2;",
    expected: "E SELECT\n1 1\no <=\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-010.txt",
    input: b"SELECT 1 <=> 2;",
    expected: "E SELECT\n1 1\no <=>\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-011.txt",
    input: b"SELECT 1 <=",
    expected: "E SELECT\n1 1\no <=",
  },
  {
    name: "test-tokens-operators-012.txt",
    input: b"SELECT NOT 1;",
    expected: "E SELECT\no NOT\n1 1\n; ;",
  },
  {
    name: "test-tokens-operators-013.txt",
    input: b"SELECT ~ 1;",
    expected: "E SELECT\no ~\n1 1\n; ;",
  },
  {
    name: "test-tokens-operators-014.txt",
    input: b"SELECT 1 */* FOO */ 2;",
    expected: "E SELECT\n1 1\no *\nc /* FOO */\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-015.txt",
    input: b"SELECT 1 := 2;",
    expected: "E SELECT\n1 1\no :=\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-016.txt",
    input: b"SELECT 1 : 2;",
    expected: "E SELECT\n1 1\n: :\n1 2\n; ;",
  },
  {
    name: "test-tokens-operators-017.txt",
    input: b"SELECT !~",
    expected: "E SELECT\no !\no ~",
  },
  {
    name: "test-tokens-operators-018.txt",
    input: b"SELECT 1 # 1;",
    expected: "E SELECT\n1 1\no #\n1 1\n; ;",
  },
  {
    name: "test-tokens-operators-019.txt",
    input: b"SELECT 1 EQV 1;",
    expected: "E SELECT\n1 1\no EQV\n1 1\n; ;",
  },
  {
    name: "test-tokens-operators-020.txt",
    input: b"SELECT 1 XOR 2;",
    expected: "E SELECT\n1 1\n& XOR\n1 2\n; ;",
  },
  {
    name: "test-tokens-string-001.txt",
    input: b"SELECT 'FOO';",
    expected: "E SELECT\ns 'FOO'\n; ;",
  },
  {
    name: "test-tokens-string-003.txt",
    input: b"SELECT \"FOO\";",
    expected: "E SELECT\ns \"FOO\"\n; ;",
  },
  {
    name: "test-tokens-string-004.txt",
    input: b"SELECT \"'FOO'\";",
    expected: "E SELECT\ns \"'FOO'\"\n; ;",
  },
  {
    name: "test-tokens-string-005.txt",
    input: b"SELECT '\"FOO\"';",
    expected: "E SELECT\ns '\"FOO\"'\n; ;",
  },
  {
    name: "test-tokens-string-006.txt",
    input: b"SELECT 'FOO\\'BAR';",
    expected: "E SELECT\ns 'FOO\\'BAR'\n; ;",
  },
  {
    name: "test-tokens-string-007.txt",
    input: b"SELECT 'FOO\\\"BAR';",
    expected: "E SELECT\ns 'FOO\\\"BAR'\n; ;",
  },
  {
    name: "test-tokens-string-008.txt",
    input: b"SELECT \"FOO\\\"BAR\";",
    expected: "E SELECT\ns \"FOO\\\"BAR\"\n; ;",
  },
  {
    name: "test-tokens-string-009.txt",
    input: b"SELECT \"FOO\\'BAR\";",
    expected: "E SELECT\ns \"FOO\\'BAR\"\n; ;",
  },
  {
    name: "test-tokens-string-010.txt",
    input: b"SELECT \"FOO",
    expected: "E SELECT\ns \"FOO",
  },
  {
    name: "test-tokens-string-011.txt",
    input: b"SELECT 'FOO",
    expected: "E SELECT\ns 'FOO",
  },
  {
    name: "test-tokens-string-012.txt",
    input: b"SELECT 'FOO\\",
    expected: "E SELECT\ns 'FOO\\",
  },
  {
    name: "test-tokens-string-013.txt",
    input: b"SELECT 'FOO\\'",
    expected: "E SELECT\ns 'FOO\\'",
  },
  {
    name: "test-tokens-string-014.txt",
    input: b"SELECT \"FOO",
    expected: "E SELECT\ns \"FOO",
  },
  {
    name: "test-tokens-string-015.txt",
    input: b"SELECT \"FOO\\",
    expected: "E SELECT\ns \"FOO\\",
  },
  {
    name: "test-tokens-string-016.txt",
    input: b"SELECT \"FOO\\\"",
    expected: "E SELECT\ns \"FOO\\\"",
  },
  {
    name: "test-tokens-string-017.txt",
    input: b"SELECT \"FOO\" \"BAR\";",
    expected: "E SELECT\ns \"FOO\"\ns \"BAR\"\n; ;",
  },
  {
    name: "test-tokens-string-018.txt",
    input: b"SELECT \"FOO\" 'BAR';",
    expected: "E SELECT\ns \"FOO\"\ns 'BAR'\n; ;",
  },
  {
    name: "test-tokens-string-019.txt",
    input: b"SELECT 'FOO' 'BAR';",
    expected: "E SELECT\ns 'FOO'\ns 'BAR'\n; ;",
  },
  {
    name: "test-tokens-string-020.txt",
    input: b"SELECT 'FOO' \"BAR\";",
    expected: "E SELECT\ns 'FOO'\ns \"BAR\"\n; ;",
  },
  {
    name: "test-tokens-string-021.txt",
    input: b"'FOO' \"BAR\";",
    expected: "s 'FOO'\ns \"BAR\"\n; ;",
  },
  { name: "test-tokens-string-022.txt", input: b"$$FOO$$", expected: "s $FOO$" },
  {
    name: "test-tokens-string-023.txt",
    input: b"$foo$foo$foo$",
    expected: "s $foo$",
  },
  {
    name: "test-tokens-string-024.txt",
    input: b"$foo$ 1 $bar$ 2 $foo$ other",
    expected: "s $ 1 $bar$ 2 $\nn other",
  },
  { name: "test-tokens-string-025.txt", input: b"$$FOO$", expected: "s $FOO$" },
  {
    name: "test-tokens-string-026.txt",
    input: b"$$FOO$$more",
    expected: "s $FOO$\nn more",
  },
  {
    name: "test-tokens-string-027.txt",
    input: b"$$FOO BAR$$more",
    expected: "s $FOO BAR$\nn more",
  },
  {
    name: "test-tokens-string-028.txt",
    input: b"$foo$FOO BAR$foo$more",
    expected: "s $FOO BAR$\nn more",
  },
  {
    name: "test-tokens-string-029.txt",
    input: b"$foo$FOO BAR",
    expected: "s $FOO BAR",
  },
  { name: "test-tokens-string-030.txt", input: b"$foo", expected: "n $\nn foo" },
  {
    name: "test-tokens-string-031.txt",
    input: b"$foo!",
    expected: "n $\nn foo\no !",
  },
  {
    name: "test-tokens-string-032.txt",
    input: b"$!foo",
    expected: "n $\no !\nn foo",
  },
  { name: "test-tokens-string-033.txt", input: b"U", expected: "n U" },
  { name: "test-tokens-string-034.txt", input: b"U&", expected: "n U\no &" },
  { name: "test-tokens-string-035.txt", input: b"U&'", expected: "s u" },
  { name: "test-tokens-string-036.txt", input: b"U&'foo", expected: "s ufoo" },
  { name: "test-tokens-string-037.txt", input: b"U&'foo'", expected: "s ufoou" },
  {
    name: "test-tokens-string-038.txt",
    input: b"U&'foo'bar",
    expected: "s ufoou\nn bar",
  },
  {
    name: "test-tokens-string-039.txt",
    input: b"U&\"",
    expected: "n U\no &\ns \"",
  },
  { name: "test-tokens-string-040.txt", input: b"q", expected: "n q" },
  { name: "test-tokens-string-041.txt", input: b"q'", expected: "n q\ns '" },
  { name: "test-tokens-string-042.txt", input: b"q'!", expected: "s q" },
  {
    name: "test-tokens-string-043.txt",
    input: b"q'!foo!'",
    expected: "s qfooq",
  },
  { name: "test-tokens-string-044.txt", input: b"q'!foo!", expected: "s qfoo!" },
  {
    name: "test-tokens-string-045.txt",
    input: b"q'!foo!'more",
    expected: "s qfooq\nn more",
  },
  {
    name: "test-tokens-string-046.txt",
    input: b"q'!foo!bar!'more",
    expected: "s qfoo!barq\nn more",
  },
  {
    name: "test-tokens-string-047.txt",
    input: b"q'(foo)'",
    expected: "s qfooq",
  },
  {
    name: "test-tokens-string-048.txt",
    input: b"q'<foo>'",
    expected: "s qfooq",
  },
  {
    name: "test-tokens-string-049.txt",
    input: b"q'{foo}'",
    expected: "s qfooq",
  },
  {
    name: "test-tokens-string-050.txt",
    input: b"q'[foo]'",
    expected: "s qfooq",
  },
  { name: "test-tokens-string-051.txt", input: b"n", expected: "n n" },
  { name: "test-tokens-string-052.txt", input: b"nq", expected: "n nq" },
  {
    name: "test-tokens-string-053.txt",
    input: b"nq'! foo !'",
    expected: "s q foo q",
  },
  {
    name: "test-tokens-string-054.txt",
    input: b"nq'! foo !'more",
    expected: "s q foo q\nn more",
  },
  {
    name: "test-tokens-string-055.txt",
    input: b"NQ'! foo !'more",
    expected: "s q foo q\nn more",
  },
  {
    name: "test-tokens-string-056.txt",
    input: b"Nq'! foo !'more",
    expected: "s q foo q\nn more",
  },
  {
    name: "test-tokens-string-057.txt",
    input: b"nQ'! foo !'more",
    expected: "s q foo q\nn more",
  },
  {
    name: "test-tokens-string-058.txt",
    input: b"Q'! foo !'more",
    expected: "s q foo q\nn more",
  },
  {
    name: "test-tokens-string-059.txt",
    input: b"select '1\\\\''2';",
    expected: "E select\ns '1\\\\''2'\n; ;",
  },
  {
    name: "test-tokens-string-060.txt",
    input: b"select 1,'\\\\\\'',2;",
    expected: "E select\n1 1\n, ,\ns '\\\\\\''\n, ,\n1 2\n; ;",
  },
  {
    name: "test-tokens-string-061.txt",
    input: b"select N'123';",
    expected: "E select\ns '123'\n; ;",
  },
  {
    name: "test-tokens-string-062.txt",
    input: b"select n'123';",
    expected: "E select\ns '123'\n; ;",
  },
  {
    name: "test-tokens-string-063.txt",
    input: b"select n'';",
    expected: "E select\ns ''\n; ;",
  },
  {
    name: "test-tokens-string-064.txt",
    input: b"select n N;",
    expected: "E select\nn n\nn N\n; ;",
  },
  {
    name: "test-tokens-string-065.txt",
    input: b"select n'",
    expected: "E select\nn n\ns '",
  },
  {
    name: "test-tokens-string-066.txt",
    input: b"select E'123';",
    expected: "E select\ns '123'\n; ;",
  },
  {
    name: "test-tokens-string-067.txt",
    input: b"select e'123';",
    expected: "E select\ns '123'\n; ;",
  },
  {
    name: "test-tokens-string-068.txt",
    input: b"select e'';",
    expected: "E select\ns ''\n; ;",
  },
  {
    name: "test-tokens-string-069.txt",
    input: b"select e E;",
    expected: "E select\nn e\nn E\n; ;",
  },
  {
    name: "test-tokens-string-070.txt",
    input: b"select e'",
    expected: "E select\nn e\ns '",
  },
  {
    name: "test-tokens-string-071.txt",
    input: b";$s$s$$",
    expected: "; ;\ns $s$$",
  },
  {
    name: "test-tokens-variables-001.txt",
    input: b"SELECT @;",
    expected: "E SELECT\nv @\n; ;",
  },
  {
    name: "test-tokens-variables-002.txt",
    input: b"SELECT @@;",
    expected: "E SELECT\nv @@\n; ;",
  },
  {
    name: "test-tokens-variables-003.txt",
    input: b"SELECT @VERSION;",
    expected: "E SELECT\nv @VERSION\n; ;",
  },
  {
    name: "test-tokens-variables-004.txt",
    input: b"SELECT @@VERSION;",
    expected: "E SELECT\nv @@VERSION\n; ;",
  },
  {
    name: "test-tokens-variables-005.txt",
    input: b"SELECT @",
    expected: "E SELECT\nv @",
  },
  {
    name: "test-tokens-variables-006.txt",
    input: b"SELECT @'foo'",
    expected: "E SELECT\nv @'foo'",
  },
  {
    name: "test-tokens-variables-007.txt",
    input: b"SELECT @\"foo\"",
    expected: "E SELECT\nv @\"foo\"",
  },
  {
    name: "test-tokens-variables-008.txt",
    input: b"SELECT @a\"foo\"",
    expected: "E SELECT\nv @a\ns \"foo\"",
  },
  {
    name: "test-tokens-variables-009.txt",
    input: b"SELECT @a'foo'",
    expected: "E SELECT\nv @a\ns 'foo'",
  },
  {
    name: "test-tokens-variables-010.txt",
    input: b"SELECT @a`foo`",
    expected: "E SELECT\nv @a\nn foo",
  },
  {
    name: "test-tokens-variables-011.txt",
    input: b"SELECT @a`from 1`",
    expected: "E SELECT\nv @a\nn from 1",
  },
  {
    name: "test-tokens-variables-012.txt",
    input: b"SELECT @a`",
    expected: "E SELECT\nv @a\nn",
  },
  {
    name: "test-tokens-variables-013.txt",
    input: b"SELECT @a``",
    expected: "E SELECT\nv @a\nn",
  },
  {
    name: "test-tokens-variables-014.txt",
    input: b"SELECT @a'",
    expected: "E SELECT\nv @a\ns '",
  },
  {
    name: "test-tokens-variables-015.txt",
    input: b"SELECT @a''",
    expected: "E SELECT\nv @a\ns ''",
  },
]
