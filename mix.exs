defmodule TowerHoneybadger.MixProject do
  use Mix.Project

  @description "Error tracking and reporting to Honeybadger"
  @source_url "https://github.com/mimiquate/tower_honeybadger"
  @version "0.2.2"

  def project do
    [
      app: :tower_honeybadger,
      description: @description,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "TowerHoneybadger",
      source_url: @source_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :public_key],
      env: [honeybadger_base_url: "https://api.honeybadger.io/v1", api_key: nil, environment: nil]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:tower, "~> 0.7.1"},
      {:plug, "~> 1.14"},

      # Dev
      {:blend, "~> 0.5.0", only: :dev},
      {:ex_doc, "~> 0.37.1", only: :dev, runtime: false},

      # Test
      {:bandit, "~> 1.5", only: :test},
      {:bypass, github: "mimiquate/bypass", branch: "master", only: :test}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
