# homebrew-google-authenticator
Homebrew Formula for `google/google-authenticator-libpam` PAM module.

**NOTE:** this project is deprecated; use the official [Homebrew](http://brew.sh) formula instead.

### Installation

Install using [Homebrew](http://brew.sh)

### Post-Installation Setup

For each user on the system, run `google-authenticator` interactively using:
```sh
google-authenticator
```
or non-interactively with the secure defaults:
```sh
google-authenticator --force --time-based --disallow-reuse --rate-limit=3 --rate-time=30 --window-size=3
```

Add one of the following to one or more services in `/etc/pam.d/` (typically `/etc/pam.d/sshd`):
```
auth       required       /usr/local/lib/security/pam_google_authenticator.so
```
to require use of Google Authenticator, or:
```
auth       required       /usr/local/lib/security/pam_google_authenticator.so nullok
```
to allow users to skip Google Authenticator if they haven't set it up.

You can limit authentication methods available to clients connecting from external networks by following [this example](https://gist.github.com/jabenninghoff/a0a7f0e15dcb1e74b6e1).
