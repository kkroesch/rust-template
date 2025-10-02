# Rust Project Template 🚀

A personal Rust project template with:

* 🔧 **Justfile** (build tasks, MUSL builds, dependency installation)
* ⚡ **sccache + mold/lld** for faster builds
* 🏎 **dev-fast** profile for quick iteration
* 📦 **pnpm/corepack helpers** for frontend or hybrid projects

---

## Usage

Create a new project from this template:

```
gh repo create myproject --template kkroesch/rust-template
```

Then run:

```
just deps       # install system dependencies (Ubuntu/Debian/Fedora auto-detect)
just dev-fast   # fast incremental build
just release    # optimized release build
just musl       # portable MUSL binary build
just install    # copy binary to ~/.local/bin
```

---

## Profiles

* **dev**: default Cargo dev profile
* **dev-fast**: inherits dev, adds light optimizations and incremental builds
* **release**: optimized with incremental compilation enabled

---

## Requirements

* Rust via [rustup](https://rustup.rs/)
* `sccache` for compiler caching
* `mold` or `lld` for fast linking
* Node.js + pnpm (if you use frontend or codegen steps)

---

## Optional Commands

* `just check` → type-check only
* `just test` → run tests
* `just bench` → run benchmarks
* `just node-setup` → enable corepack and pnpm
* `just pnpm-install` → install JS deps
* `just pnpm-prep` → run prep scripts (e.g. codegen)
* `just pnpm-prune` → cleanup pnpm store
* `just cli crate=my-crate` → build only a specific crate
* `just frontend` → run frontend build via pnpm

---

## System Dependencies

Quick setup with:

```
just deps
```

This will auto-detect Ubuntu, Debian, or Fedora and install:

* build-essential / gcc, clang, pkg-config
* OpenSSL headers
* mold or lld (fast linkers)
* Node.js, npm, pnpm (via corepack)
* musl tools for static builds
* sccache
