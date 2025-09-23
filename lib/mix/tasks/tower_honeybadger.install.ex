defmodule Mix.Tasks.TowerHoneybadger.Install.Docs do
  @moduledoc false

  @spec short_doc() :: String.t()
  def short_doc do
    "Installs TowerHoneybadger"
  end

  @spec example() :: String.t()
  def example do
    "mix tower_honeybadger.install"
  end

  @spec long_doc() :: String.t()
  def long_doc do
    """
    #{short_doc()}

    ## Example

    ```sh
    #{example()}
    ```
    """
  end
end

if Code.ensure_loaded?(Igniter) and
     Code.ensure_loaded?(Tower.Igniter) and
     function_exported?(Tower.Igniter, :runtime_configure_reporter, 3) do
  defmodule Mix.Tasks.TowerHoneybadger.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{group: :tower, example: __MODULE__.Docs.example()}
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      igniter
      |> Tower.Igniter.reporters_list_append(TowerHoneybadger)
      |> Tower.Igniter.runtime_configure_reporter(
        :tower_honeybadger,
        api_key: code_value(~s[System.get_env("HONEYBADGER_API_KEY")])
      )
    end

    defp code_value(value) do
      {:code, Sourceror.parse_string!(value)}
    end
  end
else
  defmodule Mix.Tasks.TowerHoneybadger.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    @error_message """
    Task 'tower_honeybadger.install' requires igniter and tower >= 0.8.4. Please verify that those conditions are met in your project.

    For more information, see: https://hexdocs.pm/igniter/readme.html#installation
    """

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error(@error_message)
      exit({:shutdown, 1})
    end
  end
end
