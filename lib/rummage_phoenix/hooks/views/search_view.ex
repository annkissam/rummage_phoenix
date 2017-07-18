defmodule Rummage.Phoenix.SearchView do
  @moduledoc """
  Search View Module for Rummage. This has view helpers that can generate rummagable links and forms.

  Usage:

    ```elixir
    defmodule MyApp.ProductView do
      use MyApp.Web, :view
      use Rummage.Phoenix.View, only: [:search]
    end
    ```

    OR

    ```elixir
    defmodule MyApp.ProductView do
      use MyApp.Web, :view
      use Rummage.Phoenix.View
    end
    ```

  """

  import Phoenix.HTML
  import Phoenix.HTML.Form

  @doc """
  This macro includes the helpers functions for searching.

  Provides helpers function `search_form/3` for creating search form in an html.eex
  file of using `Phoenix`.

  Usage:
  Just add the following code in the index template. Make sure that you're passing
  rummage from the controller. Please look at the
  [README](https://github.com/Excipients/rummage_phoenix) for more details

  ```elixir
  <%= search_form(@conn, @rummage, [fields:
  [
    name: %{label: "Search by Product Name", search_type: "ilike"},
    price: %{label: "Search by Price", search_type: "eq"},
  ], button_class: "btn",
  ]) %>
  ```
  """
  def search_form(conn, rummage, link_params, opts \\ []) do
    search = rummage["search"]
    sort = if rummage["sort"], do: Poison.encode!(rummage["sort"]), else: ""
    paginate = if rummage["paginate"], do: Poison.encode!(rummage["paginate"]), else: ""

    button_class = Keyword.get(link_params, :button_class, "btn btn-primary")
    button_label = Keyword.get(link_params, :button_label, "Search")
    fields = Keyword.fetch!(link_params, :fields)

    form_for(conn, apply(opts[:helpers], String.to_atom("#{opts[:struct]}_path"), [conn, :index]), [as: :rummage, method: :get], fn(f) ->
      {
        :safe,
        elem(hidden_input(f, :sort, value: sort, class: "form-control"), 1) ++
        elem(hidden_input(f, :paginate, value: paginate, class: "form-control"), 1) ++
        elem(inputs_for(f, :search, fn(s) ->
          {
            :safe,
            inner_form(s, fields, search)
          }
          end), 1) ++
        elem(submit(raw(button_label), class: button_class), 1)
      }
    end)
  end

  defp inner_form(s, fields, search) do
    Enum.map(fields, fn(field) ->
      field_name = elem(field, 0)
      field_params = elem(field, 1)
      label = field_params[:label] || "Search by #{Phoenix.Naming.humanize(field_name)}"
      search_type = field_params[:search_type] || "like"
      assoc = case field_params[:assoc] do
          nil -> ""
          assocs -> Enum.join(assocs, " -> ")
        end

      elem(label(s, field_name, label, class: "control-label"), 1) ++
      elem(inputs_for(s, field_name, fn(e) ->
        {
          :safe,
          elem(hidden_input(e, :search_type, value: search_type, class: "form-control"), 1) ++
          elem(hidden_input(e, :assoc, value: assoc, class: "form-control"), 1) ++
          elem(search_input(e, :search_term, value: search[Atom.to_string(field_name)]["search_term"], class: "form-control"), 1)
        }
        end), 1)
    end) |> Enum.reduce([], & &2 ++ &1)
  end
end
