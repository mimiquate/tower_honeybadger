defmodule TowerHoneybadger.Honeybadger.Notice do
  def from_tower_event(%Tower.Event{
        kind: :error,
        reason: exception,
        stacktrace: stacktrace,
        plug_conn: plug_conn
      }) do
    error_notice(
      inspect(exception.__struct__),
      Exception.message(exception),
      stacktrace,
      plug_conn
    )
  end

  def from_tower_event(%Tower.Event{
        kind: :throw,
        reason: reason,
        stacktrace: stacktrace,
        plug_conn: plug_conn
      }) do
    error_notice("(throw)", reason, stacktrace, plug_conn)
  end

  def from_tower_event(%Tower.Event{
        kind: :exit,
        reason: reason,
        stacktrace: stacktrace,
        plug_conn: plug_conn
      }) do
    error_notice("(exit)", Exception.format_exit(reason), stacktrace, plug_conn)
  end

  defp error_notice(class, message, stacktrace, plug_conn) do
    %{
      "error" => %{
        "class" => class,
        "message" => message,
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
    |> Enum.map(&backtrace_entry/1)
  end

  defp backtrace_entry({m, f, a, location}) do
    backtrace_entry = %{
      "method" => backtrace_entry_method(m, f, a)
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
  end

  defp backtrace_entry_method(m, f, arity) when is_integer(arity) do
    Exception.format_mfa(m, f, arity)
  end

  defp backtrace_entry_method(m, f, args) when is_list(args) do
    Exception.format_mfa(m, f, length(args))
  end

  defp maybe_put_request_data(notice, %Plug.Conn{} = conn) do
    notice
    |> Map.put("request", request_data(conn))
  end

  defp maybe_put_request_data(notice, _) do
    notice
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
    Application.fetch_env!(:tower_honeybadger, :environment)
  end
end
