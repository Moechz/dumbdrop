# Changelog

All notable user-visible changes to the DumbDrop TOS application package.

## 2026.11.14-4 — 2026-11-21

Remediation of the App Center listing review for `2026.11.14-3` (aarch64).
That submission was on hold; this build supersedes it and is resubmitted after
withdrawing the old version. The `x86_64` `2026.11.14-3` listing had already
been published and stays in the store history.

### Fixed

- **D18 / F2 — the aarch64 container never reached a running state
  (`exec /bin/sh: exec format error`).** The old image,
  `moechz/dumbdrop:2026.11.14`, is a **single `linux/amd64` OCI manifest**
  (verified against the registry: one image manifest, no `linux/arm64` entry).
  On arm64 the kernel cannot execute its binaries, so the service restarted
  until the install test gave up and the app could not be opened. The package
  now pulls the official upstream image
  `dumbwareio/dumbdrop:sha-ff8f813f493e89c7da056e7a3101ce2ef48e3960`, an OCI
  image index with native `linux/amd64`
  (`sha256:9b4584d1cc4ee456aabd7271428f422dd349d9cc89e923ca42d22732e1cc93ad`)
  and `linux/arm64`
  (`sha256:43b9a29dda1f92fb6b5a92894acb158bb9250186720b872f873215ee204e7d88`)
  manifests; the index digest is
  `sha256:8a377413d4e041410ec734deb1ad085caa3adfeebeab0f6f342272d234b86e52`.
  The tag is a commit tag, never `latest`.
- **First-start copy removed.** The old wrapper copied the whole image tree
  (`/usr/src/app`, about 355 MB with `node_modules`) into `/data/app` on first
  start. That wasted disk space, slowed start-up and contributed to the install
  test timing out. The wrapper now starts the application directly from the
  image tree and only prepares `/data/uploads` and `HOME=/data`.
- **Start-up configuration.** `HOME` and `UPLOAD_DIR` are now set explicitly
  (`/data`, `/data/uploads`) for the non-root uid 1000, so the service never
  resolves its data directory to an unwritable location.

### Added

- **Privacy policy** (`PRIVACY.md`): what is stored (uploaded files, upload
  metadata, PIN cookie, container logs), the exact storage paths, the absence of
  outbound traffic and third-party sharing by default, the optional Apprise
  notification path, the retention period (no automatic expiry; stale upload
  metadata is cleaned after ~30 minutes), user rights, security measures and the
  deletion channel. The package `help` field and `config.ini` point to
  <https://github.com/Moechz/dumbdrop/blob/main/PRIVACY.md>, so the document
  opens from App Center and from the public repository (C3/C4/C5).
- **Licence notice** (`NOTICE.md`): upstream DumbDrop is **GPL-3.0** (the old
  metadata incorrectly said MIT), the upstream copyright, the pinned image tag
  and all three digests, the components inside the image (Node.js, Alpine,
  Apprise) and a trademark/affiliation statement (C2). The full GPL-3.0 text is
  included as `LICENSE-GPL-3.0`; the packaging itself stays MIT (`LICENSE`).
- **Complete source repository and README** (`README.md`): what the package is,
  the full repository layout, architecture support, privacy summary, notices,
  install/upgrade/removal notes, security limitations, build and verification
  commands, and a table mapping every review item to its fix (C10). The public
  repository previously contained only a README with no source.

### Fixed (continued)

- **C9 — description inconsistent with delivered functionality.** The English
  description now lists what DumbDrop actually does (drag files or folders onto
  the page, folder structure preserved, optional 4–10 digit PIN, size limit,
  extension allow-list, auto-upload, optional file list with download/delete,
  Apprise notifications) and states that files do not expire automatically. The
  Simplified and Traditional Chinese descriptions and install notes were
  leftover text from a **different application (a habit tracker, including a
  `beaverhabitsdocker` data path)**; they now describe DumbDrop, its upload
  directory and its optional PIN. All 23 language sections were regenerated with
  the corrected release note.
- **C2 metadata.** `tosapp.json` now declares GPL-3.0 for the upstream
  application instead of the incorrect MIT value.
- Stale build metadata in `tosapp.json` was removed: a `probe` block that
  belonged to another application (BeaverHabits: image digest, ports, health
  check and log tail), a healthcheck for a non-existent `healthcheck.py`, an
  `entrypoint_file` pointing outside this repository, and `UPLOAD_DIR` without
  the matching `HOME`. The spec now matches the files that are built.

### Security

- **T1 — high/critical CVE in the upstream image, retained with reason.** The
  upstream DumbDrop repository has **no release, tag or commit newer than**
  `ff8f813f493e` (2025-11-10); Docker Hub has no image built from a newer commit
  either. The official multi-arch image pinned above is that build (Node.js
  22.21.1 on Alpine 3.22.2). There is no newer upstream image to upgrade to, and
  this package does not redistribute or rebuild the application, so the affected
  runtime components cannot be patched from this repository without forking the
  upstream image. The finding remains tracked: it will be re-checked on the next
  upstream release, and the package will be rebuilt on the fixed image as soon
  as one exists. Mitigations available today: keep the app on the LAN, do not
  expose port 8162, and set `DUMBDROP_PIN`.

### Changed

- Version bumped from `2026.11.14-3` to `2026.11.14-4` (upstream base
  unchanged).
- Image changed from the maintainer's amd64-only mirror to the official
  upstream multi-arch commit tag.
- Host port remains **8162** (port collisions between App Center applications
  are expected and are not treated as a package defect).

## 2026.11.14-3 — 2026-11-20 (aarch64 withdrawn)

**Superseded by `2026.11.14-4`.** The aarch64 submission was placed on hold by
the listing review; the store version was withdrawn and replaced. The x86_64
package had already been published and remains in the store history.

### Known issue

- Used `moechz/dumbdrop:2026.11.14`, a single `linux/amd64` manifest. The
  aarch64 package could not start (`exec format error`), and the app could not
  be opened during the install test.

## 2026.11.14-1 — 2026-11-14

### Added

- First release. DumbDrop (`moechz/dumbdrop:2026.11.14`, Docker Hub, used
  unmodified) packaged as a TOS 7 Docker application, published on port 8162 and
  running as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/dumbdropdocker/`.
