defmodule TowerHoneybadger.Reporter do
  @behaviour Tower.Reporter

  @impl true
  def report_event(%Tower.Event{kind: :message}) do
    if enabled?() do
      IO.puts("TowerHoneybadger DOES NOT support reporting messages, ignoring...")
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
