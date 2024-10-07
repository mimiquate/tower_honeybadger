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
end
