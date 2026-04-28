# HackTricks Docker

Run the [HackTricks](https://github.com/HackTricks-wiki/hacktricks) wiki locally via [mdbook](https://rust-lang.github.io/mdBook/) in a container. Works with **Podman** or **Docker**.

## Prerequisites

- **Podman** or **Docker**, with **Compose** available (`docker compose`, `podman compose`, or `docker-compose`)
- **Git** (to clone the HackTricks repo)

## Quick start

1. **Clone this repo** (if you haven’t already):
   ```bash
   git clone <this-repo-url>
   cd hacktricks-docker
   ```

2. **Ensure the HackTricks wiki is present.**  
   If the `hacktricks/` directory doesn’t exist or isn’t a git repo, clone it:
   ```bash
   git clone https://github.com/HackTricks-wiki/hacktricks
   ```

3. **Build and run** (foreground; logs in the terminal):
   ```bash
   docker compose up --build
   ```
   Or with **Podman**:
   ```bash
   podman compose up --build
   ```

4. **Open in a browser:**  
   [http://localhost:8002](http://localhost:8002)  
   The container listens on port **3337**; `docker-compose.yml` maps **host 8002 → container 3337**. Change the `ports` entry if you want another host port.

To run in the **background**:
```bash
docker compose up --build -d
```

Stop and remove the stack:
```bash
docker compose down
```

View logs when running detached:
```bash
docker compose logs -f
```

### Optional: `build.sh`

If you prefer a single script (picks **Podman** when installed, else **Docker**) instead of Compose:

```bash
./build.sh
```

That maps **localhost:3337** on the host. Adjust the `-p` line in `build.sh` if it clashes with other services.

## Troubleshooting

If the service stops immediately, check:
```bash
docker compose ps -a
docker compose logs
```

## Manual commands (without Compose)

**Build only:**
```bash
podman build -t hacktricks-arm64 .
# or
docker build -t hacktricks-arm64 .
```

**Run (detached):**
```bash
podman run --rm -d -p 127.0.0.1:3337:3337 -v "$(pwd)/hacktricks:/app" --name my-hacktricks hacktricks-arm64
```

**Run (foreground, to see logs):**
```bash
podman run --rm -p 127.0.0.1:3337:3337 -v "$(pwd)/hacktricks:/app" hacktricks-arm64
```

**Stop the container:**
```bash
podman stop my-hacktricks
# or
docker stop my-hacktricks
```

## Project layout

| Path | Description |
|------|-------------|
| `Dockerfile` | Multi-stage build: Rust image builds mdbook + mdbook-tabs; final image is minimal Alpine with Python and the binaries. |
| `docker-compose.yml` | Builds `hacktricks-arm64`, mounts `./hacktricks` at `/app`, publishes the book (see port mapping there). |
| `build.sh` | Optional: build and run with Podman or Docker (no Compose). |
| `hacktricks/` | Clone of [HackTricks-wiki/hacktricks](https://github.com/HackTricks-wiki/hacktricks); created by you. Not committed to git (see `.gitignore`). |

## Port and networking

- Inside the container, mdbook serves on **3337**.
- **Compose** maps **127.0.0.1:8002** → container **3337** by default. Edit `docker-compose.yml` (e.g. `"127.0.0.1:3337:3337"` or `"3337:3337"` for LAN access) to change it.

## License

This repo is for running HackTricks locally. The HackTricks wiki content is under its own license in the [HackTricks-wiki/hacktricks](https://github.com/HackTricks-wiki/hacktricks) repository.
