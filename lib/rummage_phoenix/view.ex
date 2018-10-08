defmodule Rummage.Phoenix.View do
  @moduledoc """
  View Module for Rummage. This has view helpers that can generate rummagable links and forms.

  Usage:

  ```elixir
  defmodule MyApp.ProductView do
    use MyApp.Web, :view
    use Rummage.Phoenix.View
  end
  ```
  """

  @doc """
  This macro includes the helpers functions from different Rummage.Phoenix.Views
  """
  defmacro __using__(opts) do
    quote do
      import Rummage.Phoenix.{PaginateView, SearchView, SortView, ViewResolver}
      alias Rummage.Phoenix.{PaginateView, SearchView, SortView, ViewResolver}

      defp helpers do
        helpers = unquote(opts[:helpers]) ||
          Rummage.Phoenix.default_helpers ||
          ViewResolver.make_helpers_name_from_topmost_namespace(__MODULE__)

        unless Code.ensure_compiled?(helpers) do
          raise """
          #{helpers} is undefined, please provide an explicit router to the View with:
          `use Rummage.Phoenix.View, helpers: MyApp.Web.Router.Helpers`"

          or through a config:

          config :rummage_phoenix, Rummage.Phoenix, [
            default_helpers: MyApp.Web.Router.Helpers,
          ]
          """
        end

        helpers
      end

      defp struct do
        struct = unquote(opts[:struct]) ||
          ViewResolver.make_struct_name_from_bottommost_namespace(__MODULE__)

        helpers = helpers()

        unless function_exported?(helpers, String.to_atom("#{struct}_path"), 2) do
          raise "#{struct}_path is undefined, please provide an explicit struct to the View with: `use Rummage.Phoenix.View, struct: \"some_model\""
        end

        struct
      end
    end
  end
end
