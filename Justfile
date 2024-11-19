release:
  @cargo build --release

useful_dependencies:
  @cargo add serde -F derive
  @cargo add tokio
  @cargo add anyhow
  @cargo add tracing tracing_subscriber

test:
  @cargo test
