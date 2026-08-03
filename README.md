# Trust SSL — macOS Fix (Local add-on)

Makes the **"Trust"** button next to a site's SSL certificate in
[Local](https://localwp.com) actually work on macOS.

## The problem

On modern macOS, clicking **Trust** in Local's SSL tab shows the admin-password
prompt, appears to succeed… and does nothing. Local runs
`security add-trusted-cert` through a background sudo helper
(`@vscode/sudo-prompt`), and in that non-interactive context macOS refuses to
write the trust settings — the certificate lands in the System keychain, but is
never actually trusted, so browsers keep warning about `https://<site>.test`.

The very same command works fine when *you* run it in a Terminal.

## The fix

This add-on takes over the `trustSiteCert` IPC channel behind the Trust button.
When you click **Trust**, instead of the broken background sudo flow it:

1. writes a small `trust-ssl.sh` script into the site's root folder,
2. opens it in a Terminal window, where you authenticate with `sudo` yourself
   (this is the part that makes macOS accept the trust settings),
3. polls the System keychain and, once the certificate is trusted, tells
   Local's UI so the button flips to **"Trusted"** — and cleans up the script.

Everything else (certificate generation, the trust-status check) is left to
Local itself. On Windows and Linux the add-on does nothing at all.

## Co-authored by Claude, Fable 5

This project is written by myself and Claude, Fable 5, and tested by myself on LocalWP version 10.1.1

## NO LIABILITY!!!!

Use at your own risk!!!!

Just because it works for me, does not mean it will work for you!

Feel free to burn it down!

I welcome every comment, positive as well as negative (though you might hurt my feelings and I might shout at you, but that's just because I care!)

Feel free to contribute!

## Install (development)

```sh
./scripts/install.sh
```

This installs dependencies, compiles, and symlinks the folder into
`~/Library/Application Support/Local/addons`. Then restart Local, enable
**Trust SSL — macOS Fix** under *Add-ons → Installed*, and relaunch.

## Build a distributable zip

```sh
./scripts/build.sh
```

Produces `dist/local-trust-ssl-macos-v<version>.zip`.

## Compatibility

Verified against Local 10.1.1 on macOS. The add-on inspects Local's internals
(the `trustSiteCert` IPC channel and the certificate location
`~/Library/Application Support/Local/run/router/nginx/certs/<domain>.crt`), so
a future Local release could change these — if the Trust button ever reverts to
its old broken behavior, check here first.

## License

GPL-3.0-or-later.
