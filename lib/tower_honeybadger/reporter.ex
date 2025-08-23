defmodule TowerHoneybadger.Reporter do
  @moduledoc false

  alias TowerHoneybadger.Honeybadger

  def report_event(%Tower.Event{kind: :message}) do
    if enabled?() do
      IO.puts("Honeybadger DOES NOT support reporting messages, ignoring...")
    else
      IO.puts("TowerHoneybadger NOT enabled, ignoring...")
    end
  end

  def report_event(%Tower.Event{} = tower_event) do
    if enabled?() do
      notice = Honeybadger.Notice.from_tower_event(tower_event)

      async(fn ->
        Honeybadger.Client.send(notice)
      end)
    else
      IO.puts("TowerHoneybadger NOT enabled, ignoring...")
    end
  end

  defp enabled? do
    !!Application.fetch_env!(:tower_honeybadger, :api_key)
  end

  defp async(fun) do
    Tower.TaskSupervisor
    |> Task.Supervisor.start_child(fun)
  end
end
