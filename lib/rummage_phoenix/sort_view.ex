defmodule Rummage.Phoenix.SortView do
  @moduledoc """
  Sort View Module for Rummage. This has view helpers that can generate rummagable links and forms.

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
  This macro includes the helper functions from different Rummage.Phoenix.SortView

  Provides helper function `sort_link/3` for creating sort links in an html.eex
  file of using `Phoenix`.

  Usage:
  Just add the following code in the index template. Make sure that you're passing
  rummage from the controller. Please look at the
  [README](https://github.com/Excipients/rummage_phoenix) for more details

  ```elixir
  sort_link(:title, @conn, @rummage)
  ```
  """
  defmacro __using__(opts) do
    quote do
      def sort_link(field, conn, rummage, name \\ nil) do
        current_sort_params = rummage["sort"]
        name = name || Phoenix.Naming.humanize(field)

        {name, sort_params} =
          cond do
            current_sort_params in [nil, "", []] -> {name, "#{field}.asc"}

            Regex.match?(~r/#{field}.asc+$/, current_sort_params) ->
              {name <> " ↓", "#{field}.desc"}

            Regex.match?(~r/#{field}.desc+$/, current_sort_params) ->
              {name <> " ↑", "#{field}.asc"}

            true -> {name, "#{field}.asc"}
          end

        raw link_with_icon(name, apply(unquote(opts[:helper]),
          String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, %{rummage: Map.put(rummage, "sort", sort_params)}]))
      end

      defp link_with_icon(name, url) do
        """
        <a class="page-link" href="#{url}">#{name}</a>
        """
      end
    end
  end
end
