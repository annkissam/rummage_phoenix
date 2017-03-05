defmodule Rummage.Phoenix.Controller do
  @moduledoc """
  Controller Module for Rummage.Phoenix. This builds rummage params and performs search action

  Usage:

  If the application is using default Rummage Hooks

  ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helpers: MyApp.Router.Helpers
  end
  ```

  If the application is using only some of the Rummage Hooks, say search and sort.

  ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helpers: MyApp.Router.Helpers,
      only: [:search, :sort]
  end
  ```

  """

  @doc """
  This macro includes the helpers functions from different Rummage.Phoenix.Controllers
  """
  defmacro __using__(opts) do
    quote do
      plug Rummage.Phoenix.Plug, %{hooks: unquote((opts[:only] || [:search, :sort, :paginate])
                                                    |> Enum.map(&Atom.to_string &1))}
    end
  end
end
