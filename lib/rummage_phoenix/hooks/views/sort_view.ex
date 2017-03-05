defmodule Rummage.Phoenix.SortView do
  @moduledoc """
  Sort View Module for Rummage. This has view helpers that can generate rummagable links and forms.

  Usage:

  Usage:

  ```elixir
  defmodule MyApp.ProductView do
    use MyApp.Web, :view
    use Rummage.Phoenix.View, only: [:paginate]
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

  @doc """
  This macro includes the helpers functions for sorting.

  Provides helpers function `sort_link/3` for creating sort links in an html.eex
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
      def sort_link(conn, rummage, link_params) do
        current_sort_params = rummage["sort"]

        field = Keyword.fetch!(link_params, :field)

        name = link_params[:name] || Phoenix.Naming.humanize(field)
        ci = link_params[:ci] || false
        assoc = link_params[:assoc] || []

        {sort_field, current_order} = get_sort_field_and_current_order(current_sort_params, field, assoc)

        sort_field = if ci, do: sort_field <> ".ci", else: sort_field

        sort_params = %{"assoc" => assoc, "field" => sort_field}

        raw link_with_icon(name, apply(unquote(opts[:helpers]),
          String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, %{rummage: Map.put(rummage, "sort", sort_params)}]), current_order)
      end

      defp link_with_icon(name, url, current_order) do
        if current_order do
          """
          <a class="page-link" href="#{url}">#{name}  <img src=\"images/#{current_order}.png\" alt=\"" height=\"10\" width=\"10\"></a>
          """
        else
          """
          <a class="page-link" href="#{url}">#{name}</a>
          """
        end
      end

      defp get_sort_field_and_current_order(current_sort_params, field, assoc) do
        cond do
          current_sort_params in [nil, "", [], %{}] -> {"#{field}.asc", nil}
          is_nil(current_sort_params["assoc"]) ->
            current_sort_field = current_sort_params["field"]
              |> String.split(".ci")
              |> Enum.at(0)

            cond do
              [] != assoc -> {"#{field}.asc", nil}

              Regex.match?(~r/#{field}.asc+$/, current_sort_field) ->
                {"#{field}.desc", "desc"}

              Regex.match?(~r/#{field}.desc+$/, current_sort_field) ->
                {"#{field}.asc", "asc"}

              true -> {"#{field}.asc", nil}
            end

          true ->
            current_assoc = current_sort_params["assoc"]

            current_sort_field = current_sort_params["field"]
              |> String.split(".ci")
              |> Enum.at(0)

            cond do
              current_assoc != assoc -> {"#{field}.asc", nil}

              Regex.match?(~r/#{field}.asc+$/, current_sort_field) ->
                {"#{field}.desc", "desc"}

              Regex.match?(~r/#{field}.desc+$/, current_sort_field) ->
                {"#{field}.asc", "asc"}

              true -> {"#{field}.asc", nil}
            end
        end
      end
    end
  end
end
