defmodule TowerHoneybadgerTest do
  use ExUnit.Case
  doctest TowerHoneybadger

  import ExUnit.CaptureLog, only: [capture_log: 1]

  setup do
    bypass = Bypass.open()

    Application.put_env(
      :tower_honeybadger,
      :honeybadger_base_url,
      "http://localhost:#{bypass.port}/"
    )

    Application.put_env(:tower_honeybadger, :api_key, "test-api-key")
    Application.put_env(:tower_honeybadger, :environment, :test)
    Application.put_env(:tower, :reporters, [TowerHoneybadger.Reporter])
    Tower.attach()

    on_exit(fn ->
      Tower.detach()
      # Application.put_env(:tower_sentry, :dsn, nil)
    end)

    {:ok, bypass: bypass}
  end

  test "reports arithmetic error", %{bypass: bypass} do
    waiting_for(fn done ->
      Bypass.expect_once(bypass, "POST", "/notices", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)

        assert(
          {
            :ok,
            %{
              "error" => %{
                "class" => "ArithmeticError",
                "message" => "bad argument in arithmetic expression",
                "backtrace" => backtrace_entries
              },
              "server" => %{
                "environment_name" => "test"
              }
            }
          } = Jason.decode(body)
        )

        assert(
          %{
            "file" => "test/tower_honeybadger_test.exs",
            "method" =>
              ~s(anonymous fn/0 in TowerHoneybadgerTest."test reports arithmetic error"/1),
            "number" => 68
          } = List.first(backtrace_entries)
        )

        done.()

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(%{"id" => "123"}))
      end)

      capture_log(fn ->
        in_unlinked_process(fn ->
          1 / 0
        end)
      end)
    end)
  end

  test "reports throw", %{bypass: bypass} do
    waiting_for(fn done ->
      Bypass.expect_once(bypass, "POST", "/notices", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)

        assert(
          {
            :ok,
            %{
              "error" => %{
                "class" => "(throw)",
                "message" => "something",
                "backtrace" => backtrace_entries
              },
              "server" => %{
                "environment_name" => "test"
              }
            }
          } = Jason.decode(body)
        )

        assert(
          %{
            "file" => "test/tower_honeybadger_test.exs",
            "method" => ~s(anonymous fn/0 in TowerHoneybadgerTest."test reports throw"/1),
            "number" => 112
          } = List.first(backtrace_entries)
        )

        done.()

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(%{"id" => "123"}))
      end)

      capture_log(fn ->
        in_unlinked_process(fn ->
          throw("something")
        end)
      end)
    end)
  end

  test "reports abnormal exit", %{bypass: bypass} do
    waiting_for(fn done ->
      Bypass.expect_once(bypass, "POST", "/notices", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)

        assert(
          {
            :ok,
            %{
              "error" => %{
                "class" => "(exit)",
                "message" => "abnormal",
                "backtrace" => backtrace_entries
              },
              "server" => %{
                "environment_name" => "test"
              }
            }
          } = Jason.decode(body)
        )

        assert(
          %{
            "file" => "test/tower_honeybadger_test.exs",
            "method" => ~s(anonymous fn/0 in TowerHoneybadgerTest."test reports abnormal exit"/1),
            "number" => 156
          } = List.first(backtrace_entries)
        )

        done.()

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(%{"id" => "123"}))
      end)

      capture_log(fn ->
        in_unlinked_process(fn ->
          exit(:abnormal)
        end)
      end)
    end)
  end

  defp waiting_for(fun) do
    # ref message synchronization trick copied from
    # https://github.com/PSPDFKit-labs/bypass/issues/112
    parent = self()
    ref = make_ref()

    fun.(fn ->
      send(parent, {ref, :sent})
    end)

    assert_receive({^ref, :sent}, 500)
  end

  defp in_unlinked_process(fun) when is_function(fun, 0) do
    {:ok, pid} = Task.Supervisor.start_link()

    pid
    |> Task.Supervisor.async_nolink(fun)
    |> Task.yield()
  end
end
