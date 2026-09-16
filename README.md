# MoonSQLGuard

把 [libinjection](https://github.com/libinjection/libinjection) 的 SQLi 检测核心移植到 MoonBit。Web 服务或离线审计拿到的是原始字段字节，这里返回是否命中、指纹和可打印的 token 文本。

固定上游：`d88a8f86d617ac8dcb9169c9f34637aaac71ac76`。许可证 BSD-3-Clause。XSS/HTML5 分支不在本库范围内。检测结果不能代替参数化查询。

## 安装

```text
moon add hutingyu-nuist/moonsqlguard
```

```moonbit
let d = @moonsqlguard.inspect(b"1 OR 1=1")
println(@moonsqlguard.format_detection(d))
```

## API

- `tokenize` / `fingerprint`：按方言和引号上下文做词法和折叠
- `inspect` / `inspect_context` / `is_sqli` / `sqli_fingerprint`：走上游的无引号、单引号、双引号和 MySQL 再解析
- `scan_fields` / `format_detection`：按字段扫描，输出 `sqli <指纹>` 或 `clean <指纹>`
- `dump_tokens` / `dump_folded` / `format_token`：testdriver 同款文本，方便和 C 夹具对拍

## 场景

登录接口把三个表单字段交给检测器。用户名是 `admin'--`，密码是普通字符串 `hunter2`，搜索框是 `1 OR 1=1`。

```text
moon run examples/web_field --target wasm-gc
```

```text
username sqli sc
password clean n
q sqli 1&1
```

审计脚本扫一行已经拆好的日志列：`user=alice`、`q=1 OR 1=1`、`ua=Mozilla/5.0`、`id=1--`。只要命中的字段，顺序和输入一致。

```text
moon run examples/log_scan --target wasm-gc
```

```text
hits 2
q sqli 1&1
id sqli 1c
```

对照 pinned testdriver 时，直接把折叠 token 打出来：`1 OR 1=1` 指纹是 `1&1`，`UNION SELECT 1` 是 `UE1`，`hello` 指纹为空。这是和 C 程序对文本，不是口头兼容。

```text
moon run examples/fixture_dump --target wasm-gc
```

## 验证

```text
moon fmt --check
moon check --target wasm-gc --deny-warn
moon test --target wasm-gc
```

本地对 pinned testdriver：`test-sqli-*` 50/50，`test-folding-*` 118/118，收录的 `test-tokens-*` 204 条期望字符串一致。当前 27 个 MoonBit 测试块走 wasm-gc；wasm / js / native 做 `check --deny-warn`。

## 边界

- 不做 URL 解码、HTML 实体解码
- 不含 XSS/HTML5 分支，也不是 WAF 或 ORM
- token 值最多 31 字节，和上游 `stoken_t` 一样
- 兼容性以夹具为准，不宣称 100% 复刻每一处 C 细节

## 许可证

BSD-3-Clause。版权与上游说明见 `LICENSE`、`THIRD_PARTY.md`。
