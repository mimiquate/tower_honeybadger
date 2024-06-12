defmodule TowerHoneybadger.Honeybadger.Notice do
  def from_exception(exception, stacktrace) when is_exception(exception) and is_list(stacktrace) do
    %{
      "error" => %{
        "class" => inspect(exception.__struct__),
        "message" => Exception.message(exception),
        "backtrace" => backtrace(stacktrace)
      }
    }
  end

  defp backtrace(stacktrace) do
    stacktrace
    |> Enum.map(fn {m, f, a, location} ->
      backtrace_entry = %{
        "method" => Exception.format_mfa(m, f, a)
      }

      backtrace_entry =
        if location[:file] do
          Map.put(backtrace_entry, "file", to_string(location[:file]))
        else
          backtrace_entry
        end

      if location[:line] do
        Map.put(backtrace_entry, "number", location[:line])
      else
        backtrace_entry
      end
    end)
    |> Enum.reverse()
  end
end
