defmodule TowerHoneybadger.Reporter do
  @moduledoc false

  def report_event(%Tower.Event{kind: :message}) do
    if enabled?() do
      IO.puts("Honeybadger DOES NOT support reporting messages, ignoring...")
    else
      IO.puts("TowerHoneybadger NOT enabled, ignoring...")
    end
  end

  def report_event(%Tower.Event{} = tower_event) do
    if enabled?() do
      tower_event
      |> TowerHoneybadger.Honeybadger.Notice.from_tower_event()
      |> TowerHoneybadger.Honeybadger.Client.send()
    else
      IO.puts("TowerHoneybadger NOT enabled, ignoring...")
    end
  end

  defp enabled? do
    !!Application.fetch_env!(:tower_honeybadger, :api_key)
  end
end
