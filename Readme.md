# Rust Template Project

Welcome to the Rust Template Project!
This repository serves as a template to kickstart your Rust projects.
It includes a basic structure, common dependencies, and examples to help you get started quickly.

## Features

- **Modular Structure**: Organized code with modules and a clear project structure.
- **Configuration Management**: Easily manage configurations using `config` and `serde`.
- **Error Handling**: Robust error handling with `anyhow`.
- **HTTP Requests**: Make HTTP requests using `reqwest`.
- **HTML Parsing**: Parse HTML using `scraper`.
- **Command Line Interface**: Interact with the command line using `rustyline`.
- **Testing**: Set up for unit and integration testing.

## Getting Started

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (1.50.0 or later)
- [Cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html)

### Installation

1. **Clone the repository**:

   ```sh
   git clone https://github.com/kkroesch/rust-template.git
   cd rust-template
   ```

2. **Build the project**:

   ```sh
   cargo build
   ```

3. **Run the project**:

   ```sh
   cargo run
   ```

### Project Structure

```text
├── Cargo.lock
├── Cargo.toml
├── README.md
├── src
│   ├── lib.rs
│   ├── main.rs
│   ├── config.rs
│   └── rectangle.rs
└── tests
    └── rectangle_test.rs
```

- **src/main.rs**: Entry point of the application.
- **src/lib.rs**: Library module, exposing the functionality.
- **src/config.rs**: Configuration management.
- **src/my_module.rs**: Example module with a struct and methods.
- **tests/integration_test.rs**: Integration tests for the project.

## Usage

### Configuration

Configure your application using `config.toml`:

```toml
notes_dir = "~/my_notes"
author = "default_author"
```

### Example Code

#### src/lib.rs

```rust
pub mod config;
pub mod my_module;
```

#### src/config.rs

```rust
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Settings {
    pub notes_dir: String,
    pub author: Option<String>,
}

impl Settings {
    pub fn new() -> Result<Self, config::ConfigError> {
        let mut s = config::Config::default();
        s.merge(config::File::with_name("config"))?;
        s.try_into()
    }
}
```

#### src/my_module.rs

```rust
pub struct MyStruct {
    pub name: String,
    pub age: u32,
}

impl MyStruct {
    pub fn new(name: &str, age: u32) -> MyStruct {
        MyStruct {
            name: name.to_string(),
            age,
        }
    }

    pub fn greet(&self) {
        println!("Hello, my name is {} and I am {} years old.", self.name, self.age);
    }
}
```

#### src/main.rs

```rust
mod config;
mod my_module;

use std::fs::File;
use std::io::{self, Write};
use std::path::PathBuf;
use chrono::prelude::*;
use ansi_term::Colour::{Red, Green, Fixed};
use rustyline::Editor;
use anyhow::{Context, Result};
use crate::config::Settings;
use crate::my_module::MyStruct;

fn main() -> Result<()> {
    if let Err(e) = run() {
        eprintln!("{}", Red.paint(format!("Error: {}", e)));
        std::process::exit(1);
    }
    Ok(())
}

fn run() -> Result<()> {
    let settings = Settings::new().map_err(|e| format!("Failed to load settings: {}", e))?;
    let notes_dir = shellexpand::tilde(&settings.notes_dir).to_string();
    let drafts_dir = PathBuf::from(&notes_dir).join("drafts");
    Ok(())
}
```

### Running Tests

Run unit and integration tests with:

```sh
cargo test
```

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Acknowledgments

- [Rust Programming Language](https://www.rust-lang.org/)
- [Cargo Package Manager](https://doc.rust-lang.org/cargo/)
- [Anyhow](https://github.com/dtolnay/anyhow)
- [Config](https://github.com/mehcode/config-rs)
- [Reqwest](https://github.com/seanmonstar/reqwest)
- [Scraper](https://github.com/causal-agent/scraper)
- [Rustyline](https://github.com/kkawakam/rustyline)
- [zaszi/rust-template](https://github.com/zaszi/rust-template) for the Github workflow.
