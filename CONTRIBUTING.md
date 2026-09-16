# Contributing

MoonSQLGuard 只接受 libinjection SQLi 核心相关的改动。

## 范围

- 可以：词法、折叠、指纹表、上下文判定、testdriver 夹具、字段扫描
- 不可以：XSS/HTML5、通用 WAF、ORM、数据库协议、URL 解码器

## 验证

```text
moon fmt --check
moon check --target wasm-gc --deny-warn
moon test --target wasm-gc
```

改折叠或判定时，先对 pinned testdriver 文本，再补回归测试。

## 提交

使用英文动词前缀：`feat`、`fix`、`test`、`docs`、`chore`。
