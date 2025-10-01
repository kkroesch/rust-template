use std::{fs::File, io::{self, Write}, path::PathBuf};

use clap::{Parser, ValueEnum};

#[derive(Copy, Clone, Debug, ValueEnum)]
enum Format {
    Text,
    Json,
    Csv,
}

#[derive(Parser, Debug)]
#[command(
    name = "mycli",
    author,
    version,
    about = "Basic CLI skeleton",
    disable_help_subcommand = true
)]
struct Cli {
    /// Output file (default: stdout)
    #[arg(short = 'o', long = "output")]
    output: Option<PathBuf>,

    /// Output format
    #[arg(short = 'f', long = "format", value_enum, default_value_t = Format::Text)]
    format: Format,
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();

    // Your program logic here — prepare some demo payload:
    let payload = match cli.format {
        Format::Text => "hello world\n".to_string(),
        Format::Json => serde_json::json!({ "msg": "hello world" }).to_string() + "\n",
        Format::Csv  => "msg\nhello world\n".to_string(),
    };

    // Output to file or stdout
    match cli.output {
        Some(path) => {
            let mut f = File::create(path)?;
            f.write_all(payload.as_bytes())?;
            f.flush()?;
        }
        None => {
            let mut out = io::stdout().lock();
            out.write_all(payload.as_bytes())?;
            out.flush()?;
        }
    }

    Ok(())
}
