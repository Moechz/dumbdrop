# Privacy policy — DumbDrop for TerraMaster TOS (`dumbdropdocker`)

**Last updated:** 2026-11-21
**Applies to:** DumbDrop package version `2026.11.14-4` and later, published by
Moechz in the TerraMaster App Center.
**Upstream project:** <https://github.com/DumbWareio/DumbDrop>
**Contact:** <https://github.com/Moechz/dumbdrop/issues>

This policy explains what the DumbDrop application package stores, where it is
stored, how long it is kept, when anything leaves your NAS, and how you can
access or delete it.

DumbDrop is a **self-hosted** application. It runs entirely on your TerraMaster
NAS inside a Docker container. The packager does not operate a server, does not
receive your files, and has no way to access your NAS. The "data controller" for
the files you upload is you, the owner/administrator of the NAS.

---

## 1. What the application stores

DumbDrop stores only the data you put into it, plus the minimum state needed to
run it:

| Data | Where it is stored | Why |
|---|---|---|
| Uploaded files and their contents | `/Volume1/DockerAppData/dumbdropdocker/data/uploads/` on the NAS | This is the file drop: files you upload are kept so you can open or download them later. |
| Folder structure of uploaded files/folders | Same directory tree | Folder uploads keep their relative paths. |
| Upload session metadata (`.metadata/*.meta`) | `/Volume1/DockerAppData/dumbdropdocker/data/uploads/.metadata/` | Lets a large or interrupted upload resume without re-sending finished chunks. Holds the upload id, target path, file size and last-activity time. Removed when the upload finishes; stale session files are removed automatically (see §4). |
| PIN access cookie (`DUMBDROP_PIN`) | Your browser only | Remembers that you entered the optional access PIN. It is `HttpOnly`, `SameSite=Strict`, expires after at most 24 hours, and is not sent to the packager. |
| Container logs | Docker's log store for the container | Operational messages (start-up, upload events, rate-limit and unauthorised-access warnings, which can include a client IP address and the requested path). These stay on your NAS and are rotated/removed according to your Docker logging configuration. |

The application does **not** create user accounts, does not ask for an e-mail
address, name, phone number or any other identity data, and does not use
cookies for advertising or analytics. There is no client-side tracking script
and no third-party font/CDN request: all UI assets are served by the container
itself.

## 2. Where the data is stored

- **On the NAS (persistent):**
  `/Volume1/DockerAppData/dumbdropdocker/data/`
  - uploads: `.../data/uploads/`
  - upload-session metadata: `.../data/uploads/.metadata/`
- **Inside the container:** `/data/uploads` (the same directory, bind-mounted).
  `HOME` is set to `/data` so node/npm and the optional Apprise client have a
  writable home; no application files are copied onto the volume.
- **In the image:** the application code and its Node.js dependencies
  (`/usr/src/app`). The image is read-only for the service; replacing or
  updating the container does not touch your uploads.

Everything the service writes on the NAS stays under
`/Volume1/DockerAppData/dumbdropdocker/`. The application does not write to
shared folders or other application data directories.

## 3. Does data leave the NAS?

**No, by default.** The package contains no analytics, telemetry, crash
reporting, advertising SDK or "phone home" code. It does not contact the
packager.

There are only two situations in which network traffic occurs:

1. **Installing or updating the container** — the NAS pulls the image
   `dumbwareio/dumbdrop` from Docker Hub, exactly like any other Docker
   application. Docker Hub sees the NAS's IP address and the requested image
   tag, as with any registry download.
2. **Optional notifications (off by default)** — if *you* set the
   `APPRISE_URL` environment variable, DumbDrop uses the bundled
   [Apprise](https://github.com/caronc/apprise) client to send a notification
   after each upload. The message contains the file name, the file size and the
   total storage used. It is sent only to the endpoint **you** configured (for
   example your own Gotify, ntfy, Discord or e-mail gateway); that provider's
   own privacy policy then applies. Leave `APPRISE_URL` empty and nothing is
   sent.

Uploads are not shared with any public cloud, and the package never uploads
files to the packager or to the upstream authors. Files can be downloaded by
anyone who can reach the web UI (and, if a PIN is configured, who knows the
PIN), so treat the port as you would a shared folder.

## 4. Retention period and expiry

- **Uploaded files do not expire automatically.** DumbDrop has no per-file or
  per-folder time-to-live and no scheduled deletion of completed uploads. A
  file stays on the NAS until you delete it, or until the application data
  directory is removed.
- **Incomplete uploads:** upload-session metadata that has had no activity for
  about **30 minutes** is cleaned up, together with partial upload artefacts and
  empty folders. This housekeeping runs in the background and on start-up.
- **PIN cookie:** at most 24 hours in the browser (some paths use a session
  cookie, which ends when the browser closes).
- **Container logs:** retained according to your Docker daemon's log rotation
  configuration; the package does not set an unlimited log policy.
- **Backups:** if you back up the NAS or the
  `/Volume1/DockerAppData/dumbdropdocker/` folder, copies of your uploads may
  exist in those backups under your backup tool's retention rules. The package
  does not create backups itself.

## 5. Your rights and how to exercise them

Because the data is on your own NAS and the packager never receives it, you
exercise your rights directly:

- **Access / portability:** uploaded files are ordinary files. Browse or copy
  them with the TOS File Manager, SSH, or any tool that can read
  `/Volume1/DockerAppData/dumbdropdocker/data/uploads/`.
- **Rectification:** replace a file by uploading a corrected copy and deleting
  the old one.
- **Erasure:** see §6 (deletion channel).
- **Restriction / objection:** stop the container, or do not configure the
  optional Apprise notifications. You can also uninstall the application; the
  data folder is removed only if you choose to delete the data during
  uninstallation.
- **Complaint:** contact the packager through
  <https://github.com/Moechz/dumbdrop/issues>; you also have the right to
  contact your local data-protection authority.

The application does not make automated decisions about you and does not
profile users.

## 6. Deletion channel

You can delete data in any of these ways:

1. **From the web UI (optional file list):** set `SHOW_FILE_LIST=true` in the
   application environment. The page then lists uploaded files and folders with
   **download** and **delete** buttons. If a PIN is configured, the list is
   protected by the same PIN.
2. **From the NAS:** delete the files/folders under
   `/Volume1/DockerAppData/dumbdropdocker/data/uploads/` with the TOS File
   Manager (or `rm` over SSH). To remove everything, delete the whole
   `/Volume1/DockerAppData/dumbdropdocker/` folder.
3. **Uninstall with data removal:** in App Center, uninstall DumbDrop and
   choose the option to delete the application data. If you uninstall while
   keeping the data, the uploads remain on disk and are reused if you reinstall.

Deletion is immediate and irreversible from the application's point of view;
the package does not keep a recycle bin or a hidden copy. Files may still exist
in NAS snapshots or backups until those are rotated out under your own policy.

## 7. Security measures

- The container runs as the non-root user `1000:1000`; it never runs
  privileged, never mounts the Docker socket and does not use host networking.
- The optional PIN is 4–10 digits, compared in constant time, and PIN
  verification is rate-limited (5 attempts per 15 minutes per client) with a
  temporary lockout. The PIN cookie is `HttpOnly` and `SameSite=Strict`.
- Upload paths are validated and sanitised; the service rejects path-traversal
  attempts and never executes uploaded content.
- Upload, download and chunk endpoints are rate-limited; `MAX_FILE_SIZE`
  (default 1024 MB) and the optional `ALLOWED_EXTENSIONS` allow-list bound what
  can be accepted.
- The web UI is served over **plain HTTP** on the LAN, because the package does
  not ship a TLS certificate. On an untrusted network, put the app behind a
  reverse proxy with TLS or reach it through a VPN. Do not expose port 8162
  directly to the internet.
- Keep the NAS, Docker Engine and the app updated. The upstream image is
  pinned by commit tag so that an unexpected `latest` change cannot alter the
  running service.

No system is perfectly secure. If you find a vulnerability in the packaging,
report it through <https://github.com/Moechz/dumbdrop/issues>.

## 8. Third-party sharing and components

The packager does not sell, rent or share personal data, and has no data to
share. The application itself only contacts a third party if you configure the
optional Apprise notification endpoint (§3), and it downloads its container
image from Docker Hub during installation.

The container image is the official upstream image, used unmodified. It
contains the DumbDrop application (GPL-3.0), Node.js, Alpine Linux and the
Python/Apprise notification client. Their licences and copyright notices are
listed in [`NOTICE.md`](NOTICE.md); the full upstream licence text is in
[`LICENSE-GPL-3.0`](LICENSE-GPL-3.0). No upstream source code is modified or
redistributed in this repository.

## 9. Children

DumbDrop is a general-purpose file utility. It is not directed at children and
does not knowingly collect data from children; the packager collects no data at
all.

## 10. Changes to this policy

This policy is versioned together with the application in the public
repository <https://github.com/Moechz/dumbdrop>. Material changes are described
in [`CHANGELOG.md`](CHANGELOG.md), and the current version is always available
at:

<https://github.com/Moechz/dumbdrop/blob/main/PRIVACY.md>

The package's `help` link points to this document, so it can be opened directly
from App Center (C3/C4/C5).
