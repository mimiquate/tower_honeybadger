defmodule TowerHoneybadger.Honeybadger.Notice do
  def from_exception(exception, stacktrace, options \\ [])
      when is_exception(exception) and is_list(stacktrace) do
    plug_conn = Keyword.get(options, :plug_conn)

    %{
      "error" => %{
        "class" => inspect(exception.__struct__),
        "message" => Exception.message(exception),
        "backtrace" => backtrace(stacktrace)
      },
      "server" => %{
        "environment_name" => environment()
      }
    }
    |> maybe_put_request_data(plug_conn)
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
  end

  defp maybe_put_request_data(notice, %Plug.Conn{} = conn) do
    notice
    |> Map.put("request", request_data(conn))
  end

  defp request_data(%Plug.Conn{} = conn) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    %{
      "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
      "params" =>
        case conn.params do
          %Plug.Conn.Unfetched{aspect: :params} -> "unfetched"
          other -> other
        end
    }
  end

  defp environment do
    Application.fetch_env!(:tower_honeybadge, :environment)
  end
end
