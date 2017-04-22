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
      import Rummage.Phoenix.ViewResolver

      use Rummage.Phoenix.SearchView, struct: struct(), helpers: helpers()

      use Rummage.Phoenix.SortView, struct: struct(), helpers: helpers()

      require Rummage.Phoenix.PaginateView
      alias Rummage.Phoenix.PaginateView

      def pagination_link(conn, rummage, opts \\ []) do
        PaginateView.pagination_link(conn, rummage, opts ++ [struct: struct(), helpers: helpers()])
      end

      defp helpers do
        unquote(opts[:helpers]) ||
        Rummage.Phoenix.default_helpers ||
        make_helpers_name_from_topmost_namespace
      end

      defp struct do
        unquote(opts[:struct]) ||
        make_struct_name_from_bottommost_namespace
      end
    end
  end
end
