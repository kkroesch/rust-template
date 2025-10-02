# Justfile for Rust workflows with sccache + mold/lld + musl builds

set shell := ["bash", "-cu"]
crate := 'rust-template'

# Compiler acceleration
export RUSTC_WRAPPER := "sccache"
export RUSTFLAGS := "-C link-arg=-fuse-ld=mold"


default:
    just dev-fast

# Debug build (incremental)
build:
    CARGO_INCREMENTAL=1 cargo build

# Fast dev build with light optimization
dev-fast:
    CARGO_INCREMENTAL=1 cargo build --profile dev-fast

# Type-check only (no binary)
check:
    cargo check

# Release build (incremental, optimized)
release:
    CARGO_INCREMENTAL=1 cargo build --release

# Portable MUSL binary
musl:
    rustup target add x86_64-unknown-linux-musl
    CARGO_INCREMENTAL=1 cargo build --release --target x86_64-unknown-linux-musl

# Clean without touching incremental cache
clean:
    cargo clean -p {{crate}}  # set crate name or omit

# Full clean (including incremental cache)
dist-clean:
    cargo clean

# Run tests
test:
    CARGO_INCREMENTAL=1 cargo test

# Run benchmarks
bench:
    CARGO_INCREMENTAL=1 cargo bench

push message:
    git add .
    git commit -m "{{message}}"
    git push

# Create and push a release tag (GitHub Action will trigger on v* tags)
publish VERSION:
    git tag v{{VERSION}}
    # Tag ins Remote pushen
    git push origin v{{VERSION}}
    echo "Pushed tag {{VERSION}}"


# --------------------------------------------------
# Extra targets
# --------------------------------------------------

# Install binary to ~/.local/bin (default bin = "main")
# Usage: just install            -> installs 'main'
#        just install mybinary   -> installs 'mybinary'
install bin="main":
    set -e
    mkdir -p "$HOME/.local/bin"
    if [[ -x "target/x86_64-unknown-linux-musl/release/{{bin}}" ]]; then \
        cp -f "target/x86_64-unknown-linux-musl/release/{{bin}}" "$HOME/.local/bin/{{bin}}"; \
    elif [[ -x "target/release/{{bin}}" ]]; then \
        cp -f "target/release/{{bin}}" "$HOME/.local/bin/{{bin}}"; \
    else \
        echo "No built binary found ({{bin}}). Please run 'just release' or 'just musl' first."; exit 1; \
    fi
    chmod +x "$HOME/.local/bin/{{bin}}"
    echo "Installed: $HOME/.local/bin/{{bin}}"

# Node setup (corepack + pnpm)
node-setup:
    set -e
    corepack enable
    corepack prepare pnpm@latest --activate
    pnpm --version

# pnpm install
pnpm-install:
    pnpm install --frozen-lockfile --prefer-offline

# pnpm prep (e.g. codegen)
pnpm-prep:
    pnpm prep

# Clean pnpm store
pnpm-prune:
    pnpm store prune

# Build only a specific crate (e.g. CLI)
cli crate="my-cli":
    cargo build --release -p {{crate}}

# Frontend / desktop build via pnpm
frontend:
    pnpm build || pnpm run build

# --------------------------------------------------
# System dependencies
# --------------------------------------------------

# Install system dependencies (auto-detects Ubuntu/Debian/Fedora)
deps:
    set -e
    if grep -qi 'ubuntu' /etc/os-release; then just deps-ubuntu; \
    elif grep -qi 'debian' /etc/os-release; then just deps-debian; \
    elif grep -qi 'fedora' /etc/os-release; then just deps-fedora; \
    else echo "Unsupported distro. Please install dependencies manually."; exit 1; fi

# Ubuntu (>=22.04 recommended)
deps-ubuntu:
    set -e
    sudo apt update
    sudo apt install -y \
      build-essential pkg-config libssl-dev \
      clang lld mold \
      nodejs npm \
      musl-tools \
      sccache
    if command -v corepack >/dev/null 2>&1; then corepack enable || true; fi

# Debian (Bookworm or newer)
deps-debian:
    set -e
    sudo apt update
    sudo apt install -y \
      build-essential pkg-config libssl-dev \
      clang lld mold \
      nodejs npm \
      musl-tools \
      sccache
    if command -v corepack >/dev/null 2>&1; then corepack enable || true; fi

# Fedora (39/40/41)
deps-fedora:
    set -e
    sudo dnf install -y \
      gcc gcc-c++ make pkgconf-pkg-config \
      openssl-devel \
      clang lld mold \
      nodejs npm \
      musl-gcc musl-devel \
      sccache
