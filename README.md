# TowerHoneybadger

[![ci](https://github.com/mimiquate/tower_honeybadger/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/mimiquate/tower_honeybadger/actions?query=branch%3Amain)
[![Hex.pm](https://img.shields.io/hexpm/v/tower_honeybadger.svg)](https://hex.pm/packages/tower_honeybadger)
[![Documentation](https://img.shields.io/badge/Documentation-purple.svg)](https://hexdocs.pm/tower_honeybadger)

Elixir error tracking and reporting to [Honeybadger](https://www.honeybadger.io/).

[Tower](https://github.com/mimiquate/tower) reporter for Honeybadger.

## Installation

Package can be installed by adding `tower_honeybadger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tower_honeybadger, "~> 0.2.0"}
  ]
end
```

## Usage

Tell `Tower` to inform `TowerHoneybadger` reporter about errors.

```elixir
# config/config.exs

config(
  :tower,
  :reporters,
  [
    # along any other possible reporters
    TowerHoneybadger
  ]
)
```

And configure `:tower_honeybadger`, with at least the API key.

```elixir
# config/runtime.exs

if config_env() == :prod do
  config :tower_honeybadger, api_key: System.get_env("HONEYBADGER_API_KEY")
end
```

That's it.

It will try report any errors (exceptions, throws or abnormal exits) within your application. That includes errors in
any plug call (including Phoenix), Oban job, async task or any other Elixir process.

Some HTTP request data will automatically be included in the report if a `Plug.Conn` if available when handling the error.

### Manual reporting

You can manually report errors just by informing `Tower` about any manually caught exceptions, throws or abnormal exits.


```elixir
try do
  # possibly crashing code
catch
  kind, reason ->
    Tower.handle_caught(kind, reason, __STACKTRACE__)
end
```

More details on https://hexdocs.pm/tower/Tower.html#module-manual-handling.

## License

Copyright 2024 Mimiquate

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
