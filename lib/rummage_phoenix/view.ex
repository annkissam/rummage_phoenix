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
      require Rummage.Phoenix.{PaginateView, SearchView, SortView, ViewResolver}
      alias Rummage.Phoenix.{PaginateView, SearchView, SortView, ViewResolver}

      def pagination_link(conn, rummage, opts \\ []) do
        PaginateView.pagination_link(conn, rummage, opts ++ [struct: struct(), helpers: helpers()])
      end

      def sort_link(conn, rummage, opts \\ []) do
        SortView.sort_link(conn, rummage, opts ++ [struct: struct(), helpers: helpers()])
      end

      def search_form(conn, rummage, link_params, opts \\ []) do
        SearchView.search_form(conn, rummage, link_params, opts ++ [struct: struct(), helpers: helpers()])
      end

      defp helpers do
        unquote(opts[:helpers]) ||
        Rummage.Phoenix.default_helpers ||
        ViewResolver.make_helpers_name_from_topmost_namespace(__MODULE__)
      end

      defp struct do
        unquote(opts[:struct]) ||
        ViewResolver.make_struct_name_from_bottommost_namespace(__MODULE__)
      end
    end
  end
end
