# dumbdrop-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [DumbDrop](https://github.com/DumbWareio/DumbDrop), a small self-hosted file
> drop.

## What this is

A four-file TOS Docker application archive (`dumbdropdocker.tar.gz`) that
installs DumbDrop on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`,
  id `dumbdropdocker`)
- `dumbdropdocker.lang` — 23-language superset (TOS requires 14)
- `dumbdropdocker.svg` — application icon (SVG, 709 bytes)
- `docker-compose.yml` — one service, image
  `dumbwareio/dumbdrop:sha-ff8f813f493e89c7da056e7a3101ce2ef48e3960`

The repository also contains the complete source of the package: the `src/`
templates, the deterministic build scripts, the review-standards self-check and
the isolated staging test.

## How it works

| | |
|---|---|
| Container image | `dumbwareio/dumbdrop:sha-ff8f813f493e89c7da056e7a3101ce2ef48e3960` — the **official multi-arch upstream image**, pinned by commit, used unmodified (`linux/amd64` + `linux/arm64`) |
| Open | `http://<NAS-IP>:8162/` (container port 3000) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/Volume1/DockerAppData/dumbdropdocker/data/` → `/data` |
| Uploads | `/Volume1/DockerAppData/dumbdropdocker/data/uploads/` |
| Logs | `docker logs dumbdropdocker` (stdout/stderr) |
| Optional PIN | set `DUMBDROP_PIN` to 4–10 digits |
| Optional file list | set `SHOW_FILE_LIST=true` to get download/delete buttons |
| Optional notifications | set `APPRISE_URL` (off by default) |

DumbDrop is deliberately small: open the page, drag files (or whole folders)
in, and they are saved on the NAS with their folder structure. A PIN gate, a
maximum file size (`MAX_FILE_SIZE`, default 1024 MB), an extension allow-list,
auto-upload, an optional file list and Apprise notifications are configurable.
It is **single-user** in the sense that there are no accounts or permissions per
user — whoever can reach the page (and knows the PIN, if set) can upload and,
with `SHOW_FILE_LIST=true`, list/download/delete files. Uploaded files **do not
expire automatically**. There is no analytics, telemetry or advertising code.

## Repository layout

```text
.
├── README.md                  this file
├── CHANGELOG.md               every published version and its review fixes
├── PRIVACY.md                 privacy policy (also the package `help` target)
├── NOTICE.md                  upstream licence, image digests, trademarks
├── LICENSE                    MIT licence for this packaging
├── LICENSE-GPL-3.0            upstream DumbDrop licence (GPL-3.0)
├── tosapp.json                app spec read by the build (id, version, image,
│                              port, volume, translations, licences)
├── src/
│   ├── config.ini             TOS metadata template (@@VERSION@@/@@PLATFORM@@)
│   ├── docker-compose.yml     one non-root service, fixed image tag
│   ├── entrypoint.sh          start-up wrapper embedded into the compose file
│   ├── dumbdropdocker.lang    23-language descriptions
│   └── dumbdropdocker.svg     store icon
├── scripts/
│   ├── build.sh               stage → verify → deterministic tar.gz + sha256
│   └── build-dual.sh          build both architectures and run the official -c
├── test/
│   └── install-and-verify.sh  on-device install / runtime verification
├── tools/
│   └── verify.py              review-standards self-check (runs in build.sh)
├── TOSAppSelfTestingTool      official TerraMaster package checker (v1.0.2)
└── .gitignore
```

## Architecture support

The previous package used `moechz/dumbdrop:2026.11.14`, which is a **single
`linux/amd64` OCI manifest**. On aarch64 hardware the container therefore died
with `exec /bin/sh: exec format error`, the service never became ready and the
install test could not open the app (review items D18/F2).

This version uses the official upstream image index instead:

| Platform | Manifest |
|---|---|
| OCI index | `sha256:8a377413d4e041410ec734deb1ad085caa3adfeebeab0f6f342272d234b86e52` |
| `linux/amd64` | `sha256:9b4584d1cc4ee456aabd7271428f422dd349d9cc89e923ca42d22732e1cc93ad` |
| `linux/arm64` | `sha256:43b9a29dda1f92fb6b5a92894acb158bb9250186720b872f873215ee204e7d88` |

`scripts/build-dual.sh` produces both `<appid>_x86_64.tar.gz` and
`<appid>_aarch64.tar.gz`; both are checked with the official
`TOSAppSelfTestingTool -c`.

## Privacy

The full policy is [PRIVACY.md](PRIVACY.md) and is linked from the package
`help` field, so it opens from App Center:

<https://github.com/Moechz/dumbdrop/blob/main/PRIVACY.md>

Short version: everything stays on your NAS under
`/Volume1/DockerAppData/dumbdropdocker/`; there is no telemetry and no outbound
traffic by default. The only optional outbound path is Apprise notifications,
which you configure yourself and which carry only file name, size and total
storage. Uploads do not expire automatically; delete them with
`SHOW_FILE_LIST=true`, the NAS file manager, or uninstall-with-data-removal.

## Notices and licensing

- Packaging files: **MIT** (see [LICENSE](LICENSE)).
- Upstream DumbDrop: **GPL-3.0** (see [LICENSE-GPL-3.0](LICENSE-GPL-3.0)).
- Image, component licences and trademark statement: [NOTICE.md](NOTICE.md).
- This is an independent community package by **Moechz**; it is not affiliated
  with the upstream project or TerraMaster.

## Build and verification

```bash
# one architecture (defaults to tosapp.json platform)
scripts/build.sh 2026.11.14-4 x86_64

# both architectures + official package check
bash scripts/build-dual.sh 2026.11.14-4

# official checker on a single package
./TOSAppSelfTestingTool -c out/dumbdropdocker_x86_64.tar.gz

# isolated runtime test (separate port and data directory; never touches
# /Volume1/DockerAppData)
python3 ../stage.py . --timeout 300
```

`build.sh` stages the four files, substitutes the version/platform
placeholders, embeds `src/entrypoint.sh` into the compose file (escaping every
`$` as `$$`), removes CRLF/BOM/AppleDouble, runs `tools/verify.py` (archive
layout, JSON validity, required fields, 14+ language coverage, version
consistency, Docker-Hub-only image, fixed tag, port range, non-root user,
per-service healthcheck/TZ/restart, data path below the application data root,
`/Volume*` wildcard ban, comment-free sequence blocks, `x-app-meta` position, no
literal secrets, icon limits), then writes a deterministic `tar.gz` and its
`sha256`.

## Install, upgrade and removal

1. Install **DockerEngine** from App Center if it is not installed yet.
2. Install **DumbDrop** from App Center (or the package file). The app listens
   on host port **8162**; open `http://<NAS-IP>:8162/`.
3. Docker applications in the TOS App Center do not support an in-place
   upgrade: to update, uninstall and reinstall. **Keep the application data**
   during uninstall; the uploads in `/Volume1/DockerAppData/dumbdropdocker/`
   are reused after reinstall.
4. To remove all data, uninstall with the "delete data" option, or delete
   `/Volume1/DockerAppData/dumbdropdocker/` in the file manager.

## Security limitations

- The web UI is plain **HTTP**; the package does not ship a TLS certificate.
  Use a VPN or a TLS reverse proxy on untrusted networks, and never expose port
  8162 directly to the internet.
- The PIN is optional and protects the page, not individual files: without a
  PIN, anyone who can reach the port can upload (and, if enabled, list/download
  files). Set `DUMBDROP_PIN` on shared networks.
- Uploaded content is stored as ordinary files and is never executed by the
  service.
- The upstream image is over a year old and has no newer upstream release; the
  high/critical CVE finding (T1) is retained with mitigations and tracked in
  [CHANGELOG.md](CHANGELOG.md).

## Review remediation (2026.11.14-4)

| Code | Item | What changed |
|---|---|---|
| D18 / F2 | aarch64 container never starts (`exec format error`) | official multi-arch image pinned by commit; removed the 355 MB first-start copy; `HOME`/`UPLOAD_DIR` point at the data volume |
| C10 | repository/directory compliance | complete public repository with source, build scripts, tests, README and layout |
| C3 | privacy policy missing | `PRIVACY.md` + `help` link in `config.ini`/`tosapp.json` |
| C4 | privacy policy incomplete | retention, rights, security, third-party sharing and deletion channel sections |
| C5 | privacy policy not accessible | direct public URL in the `help` field |
| C9 | description vs. functionality | accurate English description; Simplified/Traditional Chinese rewritten (they described a habit tracker); all 23 sections regenerated |
| C2 | intellectual property | upstream is GPL-3.0 (was declared MIT); `NOTICE.md`, `LICENSE-GPL-3.0`, corrected metadata |
| T1 | upstream CVE | no newer upstream commit/release/image exists; retained with a written remediation note and user mitigations |

## Support

Open an issue at <https://github.com/Moechz/dumbdrop/issues>. Please include the
NAS model/architecture, TOS version and `docker logs dumbdropdocker` output.

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.
