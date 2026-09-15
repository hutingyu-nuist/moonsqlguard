# One-time mechanical translation of the pinned C fold's control flow.
# The checked-in MoonBit output is reviewed/tested; this is not a C runtime bridge.
from pathlib import Path
import re,json
root=Path(__file__).resolve().parents[1]
s=(root.parent/'moonsqlguard-evidence/fold-reference.c').read_text()
c=(root.parent/'moonsqlguard-evidence/sqli-compact.c').read_text()
types=dict(re.findall(r"(TYPE_\w+) = \(int\)'((?:\\.|[^'])*)'",c))
s=s.replace('int libinjection_sqli_fold(struct libinjection_sqli_state *sf)', 'fn fold_engine(sf : Scanner, vec : Array[Token]) -> Int')
s=s.replace('stoken_t last_comment;', 'let mut last_comment = token("", 0, b"")')
s=s.replace('size_t pos = 0;', 'let mut pos = 0').replace('size_t left = 0;', 'let mut left = 0')
s=s.replace('int more = 1;', 'let mut more = true\nlet mut current_index = 0')
s=s.replace('st_clear(&last_comment);','').replace('FOLD_DEBUG;','')
s=s.replace('LIBINJECTION_SQLI_MAX_TOKENS','5')
s=s.replace('sf->tokenvec','vec')
s=re.sub(r'sf->current = &\(vec\[([^]]+)\]\);',r'current_index = \1',s)
s=s.replace('more = libinjection_sqli_tokenize(sf);','more = match sf.next() { Some(t) => { vec[current_index] = t; true }; None => { vec[current_index] = token("", 0, b""); false } }')
s=s.replace('sf->current','vec[current_index]')
s=re.sub(r'&\((vec\[[^]]+\])\)',r'\1',s)
s=re.sub(r'&(vec\[[^]]+\]|last_comment)',r'\1',s)
s=re.sub(r'st_copy\((vec\[[^]]+\]|last_comment),\s*(vec\[[^]]+\]|last_comment)\);',r'\1 = \2.duplicate()',s)
s=re.sub(r'sf->stats_folds \+= \d+;', '',s)
s=s.replace('st_is_unary_op','unary').replace('st_is_arithmetic_op','arithmetic').replace('syntax_merge_words(sf,','merge_words(')
s=re.sub(r'cstrcasecmp\("([^"\n]+)",\s*(vec\[[^]]+\])\.val,\s*vec\[[^]]+\]\.len\) == 0',r'upper_text(\2.value) == "\1"',s)
s=re.sub(r'streq\((vec\[[^]]+\])\.val, "([^"\n]+)"\)',r'\1.value == b"\2"',s)
s=re.sub(r"strchr\((vec\[[^]]+\])\.val, '_'\) != NULL",r'upper_text(\1.value).contains("_")',s)
s=re.sub(r'(vec\[[^]]+\])\.val\[(\d+)\]',r'\1.at(\2)',s)
s=re.sub(r'(vec\[[^]]+\])\.len',r'\1.value.length()',s)
s=s.replace('.type','.kind').replace('CHAR_NULL','""')
for name,val in types.items():
    if val=='\\\\': val='\\'
    s=re.sub(r'\b'+name+r'\b',json.dumps(val).replace('\\','\\\\'),s)
s=re.sub(r"'([A-Za-z])'",lambda m:str(ord(m[1])),s)
s=s.replace('while (1)','while true').replace('return (int)(left + 2);','return left + 2').replace('return (int)left;', 'return left')
s=re.sub(r'assert\(([^;]+)\);',r'guard \1 else { abort("fold invariant") }',s)
s=s.replace('";"','"SEMICOLON"').replace(';','\n').replace('"SEMICOLON"','";"').replace('->type','.kind')
(root/'fold.mbt').write_text('// Port of upstream libinjection_sqli_fold; BSD-3-Clause.\n'+s)

