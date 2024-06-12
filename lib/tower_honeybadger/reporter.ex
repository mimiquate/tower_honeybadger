defmodule TowerHoneybadger.Reporter do
  @behaviour Tower.Reporter

  alias TowerHoneybadger.Honeybadger

  @impl true
  def report_exception(exception, stacktrace, metadata \\ %{})
      when is_exception(exception) and is_list(stacktrace) do
    if enabled?() do
      Honeybadger.Client.post(
        "/notices",
        Honeybadger.Notice.from_exception(exception, stacktrace, plug_conn: plug_conn(metadata))
      )
    else
      IO.puts("TowerHoneybadger NOT enabled, ignoring exception report...")
    end
  end

  defp plug_conn(%{conn: conn}) do
    conn
  end

  defp plug_conn(_) do
    nil
  end

  defp enabled? do
    Application.get_env(:tower_honeybadger, :enabled, false)
  end
end
