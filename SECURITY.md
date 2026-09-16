# Security

MoonSQLGuard classifies untrusted input bytes. A `clean` verdict is not immunity.

- Do not skip parameterized queries because a field was classified `clean`
- The library does not URL-decode or HTML-decode; decode first if that is your contract
- Token values are capped at 31 bytes, matching upstream `stoken_t`
- This is not a WAF, XSS filter, or query builder

Report issues on the GitHub repository. Do not send exploit-only mail without a fixture.
