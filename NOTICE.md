# Notices and attributions — DumbDrop for TerraMaster TOS

This repository contains **packaging only**. The DumbDrop application is
developed and distributed by its upstream authors; it is not modified here.

## Upstream application

| | |
|---|---|
| Project | DumbDrop |
| Upstream repository | <https://github.com/DumbWareio/DumbDrop> |
| Upstream licence | **GNU General Public License v3.0 (GPL-3.0)** |
| Upstream copyright | Copyright (c) the DumbDrop / DumbWare.io authors and contributors |
| Upstream commit used | `ff8f813f493e89c7da056e7a3101ce2ef48e3960` (2025-11-10, the latest upstream commit) |
| Full licence text | [`LICENSE-GPL-3.0`](LICENSE-GPL-3.0) |

Earlier metadata in this package incorrectly stated that the upstream project is
MIT-licensed. It is **GPL-3.0**; the packaging has been corrected accordingly.

## Container image

| | |
|---|---|
| Image | `dumbwareio/dumbdrop:sha-ff8f813f493e89c7da056e7a3101ce2ef48e3960` |
| Registry | Docker Hub |
| OCI image index | `sha256:8a377413d4e041410ec734deb1ad085caa3adfeebeab0f6f342272d234b86e52` |
| `linux/amd64` manifest | `sha256:9b4584d1cc4ee456aabd7271428f422dd349d9cc89e923ca42d22732e1cc93ad` |
| `linux/arm64` manifest | `sha256:43b9a29dda1f92fb6b5a92894acb158bb9250186720b872f873215ee204e7d88` |

The image is used **unmodified**; the package only supplies a compose file, a
small start-up wrapper and the App Center metadata. The same commit-pinned,
multi-architecture image is used on both x86_64 and aarch64, so neither
architecture runs an emulated or architecture-specific fork.

The image contains, among others:

- **DumbDrop** — GPL-3.0 (see above).
- **Node.js 22** — MIT and the licences of its bundled third-party components.
- **Alpine Linux 3.22** — the licences of the Alpine packages it ships
  (musl, BusyBox, OpenSSL, etc.).
- **Apprise** — BSD-2-Clause (<https://github.com/caronc/apprise>), used only
  for the optional upload notifications.

The authoritative licence files for these components are shipped inside the
upstream image and in the upstream source repository at the commit above. No
component is relicensed by this package.

## This packaging

| | |
|---|---|
| Packaging files (`src/`, `scripts/`, `tools/`, `test/`, README, CHANGELOG, this notice) | **MIT** — see [`LICENSE`](LICENSE) |
| Copyright | Copyright (c) 2026 Moechz |
| Privacy policy | [`PRIVACY.md`](PRIVACY.md) — also the target of the package `help` link |

The packaging files are original work. They contain no copy of the upstream
application source code, so the GPL-3.0 obligations for the application are
fulfilled by the upstream project and its published image; this repository does
not redistribute a modified DumbDrop binary.

## Trademarks and affiliation

- **DumbDrop** and **DumbWare** are the names/branding of the upstream project.
  They are used here only to identify the application that this package
  installs.
- **TerraMaster** and **TOS** are trademarks of TerraMaster.
- This is an independent community package by **Moechz**. It is not affiliated
  with, endorsed by, or sponsored by DumbWare.io, the DumbDrop contributors or
  TerraMaster.
- The application icon in `src/dumbdropdocker.svg` is a generic file-drop
  glyph created for this package; it is not the upstream logo.

## Security note

The upstream project has published no release, tag or image newer than the
commit pinned above. A high/critical CVE finding in the upstream runtime
therefore cannot be fixed by moving to a newer upstream build at this time. The
finding is tracked in [`CHANGELOG.md`](CHANGELOG.md) together with the
mitigations available to users (keep the app on the LAN, do not expose port
8162, set `DUMBDROP_PIN`). This package will move to a fixed upstream image as
soon as one is published.
