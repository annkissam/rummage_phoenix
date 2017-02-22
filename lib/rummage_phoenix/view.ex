defmodule Rummage.Phoenix.View do
  @moduledoc """
  View Module for Rummage. This has view helpers that can generate rummagable links and forms.

  Usage:

  ```elixir
  defmodule MyApp.ProductView do
    use MyApp.Web, :view
    use Rummage.Phoenix.View, struct: :product, helper: MyApp.Router.Helpers,
      default_scope: MyApp.Product, repo: MyApp.Repo
  end
  ```
  """

  @doc """
  This macro includes the helper functions from different Rummage.Phoenix.Views
  """
  defmacro __using__(opts) do
    quote do
      use Rummage.Phoenix.SearchView, struct: unquote(opts[:struct]), helper: unquote(opts[:helper])

      use Rummage.Phoenix.SortView, struct: unquote(opts[:struct]), helper: unquote(opts[:helper])

      use Rummage.Phoenix.PaginateView, struct: unquote(opts[:struct]), helper: unquote(opts[:helper]),
        default_scope: unquote(opts[:default_scope]), repo: unquote(opts[:repo])
    end
  end
end
