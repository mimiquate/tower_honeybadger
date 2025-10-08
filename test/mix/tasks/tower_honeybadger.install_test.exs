if Code.ensure_loaded?(Tower.Igniter) do
  defmodule Mix.Tasks.TowerHoneybadger.InstallTest do
    use ExUnit.Case, async: true
    import Igniter.Test

    test "generates configuration" do
      test_project()
      |> Igniter.compose_task("tower_honeybadger.install", [])
      |> assert_creates(
        "config/config.exs",
        """
        import Config
        config :tower, reporters: [TowerHoneybadger]
        """
      )
      |> assert_creates(
        "config/runtime.exs",
        """
        import Config

        config :tower_honeybadger,
          api_key: System.get_env("HONEYBADGER_API_KEY"),
          environment_name: System.get_env("DEPLOYMENT_ENV", to_string(config_env()))
        """
      )
    end
  end
end
