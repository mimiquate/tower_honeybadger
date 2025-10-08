defmodule TowerHoneybadger do
  @moduledoc """
  A Tower reporter for Honeybadger

  ## Example

      config :tower, :reporters, [TowerHoneybadger]
  """

  @behaviour Tower.Reporter

  @impl true
  def report_event(event) do
    TowerHoneybadger.Reporter.report_event(event)
  end

  cond do
    Code.ensure_loaded?(JSON) ->
      def json_module, do: JSON

    Code.ensure_loaded?(Jason) ->
      def json_module, do: Jason

    true ->
      raise "You need to either include the jason package in your dependencies to make tower_honeybadger work with your current Elixir (#{System.version()}) or upgrade to Elixir 1.18+"
  end
end
