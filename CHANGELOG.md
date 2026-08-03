# Changelog

## 1.0.0 — 2026-08-03

- Initial release.
- Takes over Local's `trustSiteCert` IPC channel on macOS and routes the
  trust command through an interactive Terminal window (`trust-ssl.sh` in the
  site root), where sudo authentication actually applies the trust settings.
- Polls the System keychain and flips Local's UI to "Trusted" once the
  certificate is really trusted; removes the generated script afterwards.
