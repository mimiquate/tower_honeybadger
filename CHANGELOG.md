# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2024-10-07

### Added

- Can include less verbose `TowerHoneybadger` as reporter instead of `TowerHoneybadger.Reporter`.

### Changed

- No longer necessary to call `Tower.attach()` in your application `start`. It is done
automatically.

- Updates `tower` dependency from `{:tower, "~> 0.5.0"}` to `{:tower, "~> 0.6.0"}`.

## [0.1.2] - 2024-09-27

### Changed

- Updates plug compatibility from `~> 1.16` to `~> 1.14`, i.e. also support plug 1.15 and 1.14.

## [0.1.1] - 2024-09-27

### Changed

- Updates elixir compatibility from `~> 1.16` to `~> 1.15`, i.e. also support elixir 1.15.

## [0.1.0] - 2024-09-23

Initial release

[0.2.0]: https://github.com/mimiquate/tower_honeybadger/compare/v0.1.2...v0.2.0/
[0.1.2]: https://github.com/mimiquate/tower_honeybadger/compare/v0.1.1...v0.1.2/
[0.1.1]: https://github.com/mimiquate/tower_honeybadger/compare/v0.1.0...v0.1.1/
