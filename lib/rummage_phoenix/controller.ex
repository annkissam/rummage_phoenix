defmodule Rummage.Phoenix.Controller do
  @moduledoc """
  Controller Module for Rummage.Phoenix. This builds rummage params and performs search action

  Usage:

  If the application is using default Rummage Hooks

  ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helper: MyApp.Router.Helpers
  end
  ```

  If the application is using only some of the Rummage Hooks, say search and sort.

  ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helper: MyApp.Router.Helpers,
      only: [:search, :sort]
  end
  ```

  """

  @doc """
  This macro includes the helper functions from different Rummage.Phoenix.Controllers
  """
  defmacro __using__(opts) do
    used_hooks = (opts[:only] || [:search, :sort, :paginate])
      |> Enum.map(&Atom.to_string &1)

    quote do
      defp build_rummage_params(params) do
        unquote(Enum.each(used_hooks, fn(hook) ->
          quote do
            apply(__MODULE__, unquote(String.to_atom("rummage_#{hook}_params")), [params])
          end
        end))
      end
    end

    if "search" in used_hooks do
      quote do
        use Rummage.Phoenix.SearchController, struct: unquote(opts[:struct]), helper: unquote(opts[:helper])
      end
    end

    # Enum.each(used_hooks, fn(hook) ->
    #   controller = Module.concat("Rummage.Phoenix", "#{Macro.camelize(hook)}Controller")

    #   quote do
    #     use unquote(controller), struct: unquote(opts[:struct]), helper: unquote(opts[:helper])
    #   end
    # end)
  end
end
