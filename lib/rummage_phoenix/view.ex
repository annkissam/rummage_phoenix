defmodule Rummage.Phoenix.View do
  @moduledoc """
  View Module for Rummage. This has view helpers that can generate rummagable links and forms.
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
