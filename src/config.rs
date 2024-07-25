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
