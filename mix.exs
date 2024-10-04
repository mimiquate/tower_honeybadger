defmodule TowerHoneybadger.MixProject do
  use Mix.Project

  @description "Error tracking and reporting to Honeybadger"
  @source_url "https://github.com/mimiquate/tower_honeybadger"
  @version "0.1.2"

  def project do
    [
      app: :tower_honeybadger,
      description: @description,
      version: @version,
      elixir: "~> 1.15",
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
      {:tower, "~> 0.6.0"},
      {:plug, "~> 1.14"},

      # Dev
      {:blend, "~> 0.4.1", only: :dev},
      {:ex_doc, "~> 0.34.2", only: :dev, runtime: false},

      # Test
      {:bypass, github: "mimiquate/bypass", only: :test}
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
end
