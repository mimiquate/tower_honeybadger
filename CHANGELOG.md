# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.4] - 2025-08-23

### Added

- Allow use with Tower v0.8.x

### Changed

- Changes `tower` dependency from `{:tower, "~> 0.7.1"}` to `{:tower, "~> 0.7.1 or ~> 0.8.0"}`.

## [0.2.3] - 2025-05-03

### Dependencies

- Don't force dependency on `jason` package if Elixir's native `JSON` module is available

## [0.2.2] - 2024-11-19

### Fixed

- Properly format reported throw value

### Changed

- Updates `tower` dependency from `{:tower, "~> 0.6.0"}` to `{:tower, "~> 0.7.1"}`.

## [0.2.1] - 2024-10-24

### Fixed

- Properly report common `:gen_server` abnormal exits

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

## 0.1.0 - 2024-09-23

Initial release

[0.2.4]: https://github.com/mimiquate/tower_honeybadger/compare/v0.2.3...v0.2.4/
[0.2.3]: https://github.com/mimiquate/tower_honeybadger/compare/v0.2.2...v0.2.3/
[0.2.2]: https://github.com/mimiquate/tower_honeybadger/compare/v0.2.1...v0.2.2/
[0.2.1]: https://github.com/mimiquate/tower_honeybadger/compare/v0.2.0...v0.2.1/
[0.2.0]: https://github.com/mimiquate/tower_honeybadger/compare/v0.1.2...v0.2.0/
[0.1.2]: https://github.com/mimiquate/tower_honeybadger/compare/v0.1.1...v0.1.2/
[0.1.1]: https://github.com/mimiquate/tower_honeybadger/compare/v0.1.0...v0.1.1/
