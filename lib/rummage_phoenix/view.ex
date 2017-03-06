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
      use Rummage.Phoenix.SearchView, struct: struct(), helpers: helpers()

      use Rummage.Phoenix.SortView, struct: struct(), helpers: helpers()

      use Rummage.Phoenix.PaginateView, struct: struct(), helpers: helpers()

      defp helpers do
        unquote(opts[:helpers]) ||
        Rummage.Phoenix.default_helpers ||
        make_helpers_name_from_topmost_namespace
      end

      defp make_helpers_name_from_topmost_namespace do
        "#{__MODULE__}"
        |> String.split(".")
        |> Enum.at(1)
        |> (& "Elixir." <> &1 <> ".Router.Helpers").()
        |> String.to_atom
      end

      defp struct do
        unquote(opts[:struct]) ||
        make_struct_name_from_bottommost_namespace
      end

      defp make_struct_name_from_bottommost_namespace do
        "#{__MODULE__}"
        |> String.split(".")
        |> Enum.at(-1)
        |> String.split("View")
        |> Enum.at(0)
        |> String.downcase
        |> String.to_atom
      end
    end
  end
end
