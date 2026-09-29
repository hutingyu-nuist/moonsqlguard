# MoonSQLGuard 验收说明

这份说明对应仓库当前状态，命令在项目根目录执行。项目以 MoonBit 为主要实现语言。本地验收使用 `moon 0.1.20260920`、`moonc v0.10.14`，满足 `moonc >= 0.10.14`；CI 通过官方安装脚本获取工具链，并在后续任务开始前检查编译器版本下限。wasm-gc、wasm、js 和 native 都参加严格检查及构建，native 需要系统 C 编译器，GitHub Actions 的 Ubuntu 环境负责复现。

## 验收项目与证据

| 要求 | 仓库证据 | 复现方式 |
| --- | --- | --- |
| MoonBit 主要实现 | `*.mbt`、`moon.mod`、`moon.pkg` | `moon version --all`，确认 `moonc >= 0.10.14` |
| GitHub 公开且提交清晰 | 公开仓库与按测试、CI、文档拆分的提交记录 | 查看 GitHub `main` 分支 |
| 源码结构和核心功能 | `tokenizer.mbt`、`fold.mbt`、`fingerprint.mbt`、`detect.mbt`、`scan.mbt`、`dump.mbt` | `moon check --target wasm-gc --deny-warn` |
| README、安装、用法、示例 | `README.md` | 按 README 的安装方式和示例命令执行 |
| 持续集成 | `.github/workflows/ci.yml` | GitHub Actions 自动执行版本检查、格式、检查、构建、测试和示例 |
| 可运行样例 | `examples/web_field`、`examples/log_scan`、`examples/fixture_dump` | 分别执行三个 `moon run` 命令 |
| 核心测试 | `*_wbtest.mbt`、`public_api_test.mbt`、pinned fixture 对拍 | `moon test --target wasm-gc` |
| MoonCakes 发布 | `hutingyu-nuist/moonsqlguard@0.1.0` | 打开 MoonCakes 包页面并按验收版本同步源码 |
| OSI 许可证 | `LICENSE`、`moon.mod`、`THIRD_PARTY.md` | BSD-3-Clause，保留上游版权和许可证说明 |

## 我们怎么验的

先用 `moon version --all` 确认工具链，再从格式、四个后端、核心测试和示例输出四条线复验。完整命令如下：

```text
moon fmt --check
moon check --target wasm-gc --deny-warn
moon check --target wasm --deny-warn
moon check --target js --deny-warn
moon check --target native --deny-warn
moon build --target wasm --deny-warn
moon build --target wasm-gc --deny-warn
moon build --target js --deny-warn
moon build --target native --deny-warn
moon test --target wasm-gc
moon run examples/web_field --target wasm-gc
moon run examples/log_scan --target wasm-gc
moon run examples/fixture_dump --target wasm-gc
```

30 个测试块覆盖词法、折叠、指纹、引号/方言重解析、黑白名单、字段扫描、token 长度边界和公开 API。固定上游夹具的结果为 `test-sqli-*` 50/50、`test-folding-*` 118/118、`test-tokens-*` 204 条一致。

验收时可以直接查看 CI 中的 `Enforce moonc minimum`、`Strict checks`、`Build all backends`、`Test core and public API`。三个示例的输出已写在 README，命令执行后可以逐行比对。
