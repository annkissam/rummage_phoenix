defmodule Rummage.Phoenix.SearchView do
  @moduledoc """
  Search View Module for Rummage. This has view helpers that can generate rummagable links and forms.

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
  This macro includes the helper functions from different Rummage.Phoenix.SearchView

  Provides helper function `search_form/3` for creating search form in an html.eex
  file of using `Phoenix`.

  Usage:
  Just add the following code in the index template. Make sure that you're passing
  rummage from the controller. Please look at the
  [README](https://github.com/Excipients/rummage_phoenix) for more details

  ```elixir
  search_form(@conn, [:title], @rummage)
  ```
  """
  defmacro __using__(opts) do
    quote do
      def search_form(conn, fields, rummage) do
        search = rummage["search"]
        sort = if rummage["sort"], do: Poison.encode!(rummage["sort"]), else: ""
        paginate = if rummage["paginate"], do: Poison.encode!(rummage["paginate"]), else: ""

        form_for(conn, apply(unquote(opts[:helper]), String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :search]), [as: :rummage], fn(f) ->
          {:safe,
            elem(hidden_input(f, :sort, value: sort, class: "form-control"), 1) ++
            elem(hidden_input(f, :paginate, value: paginate, class: "form-control"), 1) ++
            inner_form(f, fields, search) ++
            elem(submit("Search", class: "btn btn-primary"), 1)
          }
        end)
      end

      defp inner_form(f, fields, search) do
        Enum.map(fields, fn(field) ->
            elem(label(f, field, "Search by #{Atom.to_string(field) |> Macro.camelize}", class: "control-label"), 1) ++
            elem(text_input(f, field, value: search[Atom.to_string(field)], class: "form-control"), 1)
        end) |> Enum.reduce([], & &2 ++ &1)
      end
    end
  end
end
