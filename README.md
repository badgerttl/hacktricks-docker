# HackTricks Docker

Run the [HackTricks](https://github.com/HackTricks-wiki/hacktricks) wiki locally via [mdbook](https://rust-lang.github.io/mdBook/) in a container. Works with **Podman** or **Docker**.

## Prerequisites

- **Podman** or **Docker**
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

3. **Build and run:**
   ```bash
   ./build.sh
   ```

4. **Open in a browser:**  
   [http://localhost:3337](http://localhost:3337)

## What `build.sh` does

- Uses **Podman** if available, otherwise **Docker**
- Builds the image `hacktricks-arm64` (multi-stage: Rust builder, then minimal runtime)
- Removes any existing container named `my-hacktricks`
- Starts a new container that mounts `./hacktricks` at `/app` and serves on port **3337**

## Manual commands

**Build only:**
```bash
podman build -t hacktricks-arm64 .
# or
docker build -t hacktricks-arm64 .
```

**Run (detached):**
```bash
podman run --rm -d -p 3337:3337 -v "$(pwd)/hacktricks:/app" --name my-hacktricks hacktricks-arm64
```

**Run (foreground, to see logs):**
```bash
podman run --rm -p 3337:3337 -v "$(pwd)/hacktricks:/app" hacktricks-arm64
```

**Stop the container:**
```bash
podman stop my-hacktricks
# or
docker stop my-hacktricks
```

## Project layout

| Path         | Description |
|-------------|-------------|
| `Dockerfile`| Multi-stage build: Rust image builds mdbook + mdbook-tabs; final image is minimal (Alpine or Debian) with Python and the binaries. |
| `build.sh`  | Builds the image, starts the container, and optionally prunes. |
| `hacktricks/` | Clone of [HackTricks-wiki/hacktricks](https://github.com/HackTricks-wiki/hacktricks); created by you or by a clone step. Not committed to git (see `.gitignore`). |

## Port

The book is served on **port 3337**. Change the `-p` mapping in `build.sh` or in your `run` command if you need another port.

## License

This repo is for running HackTricks locally. The HackTricks wiki content is under its own license in the [HackTricks-wiki/hacktricks](https://github.com/HackTricks-wiki/hacktricks) repository.
