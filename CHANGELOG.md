# Changelog

## 1.0.1 — 2026-08-09

- New icon: padlock with checkmark plus the classic Mac OS Finder face, on a light tile color matching the first-party add-on style (`bgColor` in package.json).
- Removed the `slug` field from package.json: clicking the add-on tile made Local open its marketplace detail page, which crashes ("Cannot read properties of undefined (reading 'toString')") for add-ons not published in the marketplace. Without `slug` the tile is inert, like first-party unlisted add-ons.

## 1.0.0 — 2026-08-03

- Initial release.
- Takes over Local's `trustSiteCert` IPC channel on macOS and routes the
  trust command through an interactive Terminal window (`trust-ssl.sh` in the
  site root), where sudo authentication actually applies the trust settings.
- Polls the System keychain and flips Local's UI to "Trusted" once the
  certificate is really trusted; removes the generated script afterwards.
