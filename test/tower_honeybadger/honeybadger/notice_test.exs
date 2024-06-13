defmodule TowerHoneybadger.Honeybadger.NoticeTest do
  use ExUnit.Case
  doctest TowerHoneybadger.Honeybadger.Notice

  alias TowerHoneybadger.Honeybadger

  test "from_exception" do
    Application.put_env(:tower_honeybadger, :environment, "test")

    notice =
      try do
        raise "a test"
      rescue
        exception in RuntimeError ->
          Honeybadger.Notice.from_exception(exception, __STACKTRACE__)
      end

    assert %{
             "error" => %{
               "class" => "RuntimeError",
               "message" => "a test",
               "backtrace" => [
                 %{
                   "method" =>
                     ~s(TowerHoneybadger.Honeybadger.NoticeTest."test from_exception"/1),
                   "file" => "test/tower_honeybadger/honeybadger/notice_test.exs",
                   "number" => 12
                 },
                 %{
                   "method" => _,
                   "file" => "lib/ex_unit/runner.ex",
                   "number" => _
                 },
                 %{
                   "method" => _,
                   "file" => "timer.erl",
                   "number" => _
                 },
                 %{
                   "method" => _,
                   "file" => "lib/ex_unit/runner.ex",
                   "number" => _
                 }
               ]
             },
             "server" => %{
               "environment_name" => "test"
             }
           } = notice
  end
end
