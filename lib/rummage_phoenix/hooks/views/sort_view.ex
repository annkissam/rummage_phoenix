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

  import Phoenix.HTML

  @doc """
  This macro includes the helpers functions for sorting.

  Provides helpers function `sort_link/3` for creating sort links in an html.eex
  file of using `Phoenix`.

  Usage:
  Just add the following code in the index template. Make sure that you're passing
  rummage from the controller. Please look at the
  [README](https://github.com/Excipients/rummage_phoenix) for more details

  ```elixir
  <%= sort_link @conn, @rummage, [field: :name, ci: true] %>
  ```
  """
  def sort_link(conn, rummage, link_params, opts \\ []) do
    current_sort_params = rummage["sort"]

    field = Keyword.fetch!(link_params, :field)
    asc_sort_icon = Keyword.get(link_params, :sort_icon)
    asc_sort_text = Keyword.get(link_params, :asc_sort_text, "↑")
    desc_sort_icon = Keyword.get(link_params, :sort_icon)
    desc_sort_text = Keyword.get(link_params, :desc_sort_text, "↓")


    name = link_params[:name] || Phoenix.Naming.humanize(field)
    ci = link_params[:ci] || false
    assoc = link_params[:assoc] || []

    {sort_field, current_order} = get_sort_field_and_current_order(current_sort_params, field, assoc)

    sort_field = if ci, do: sort_field <> ".ci", else: sort_field

    sort_params = %{"assoc" => assoc, "field" => sort_field}

    raw link_with_icon(name, apply(opts[:helpers],
      String.to_atom("#{opts[:struct]}_path"), [conn, :index, %{rummage: Map.put(rummage, "sort", sort_params)}]),
      current_order, asc_sort_icon, asc_sort_text, desc_sort_icon, desc_sort_text)
  end

  defp link_with_icon(name, url, current_order,  asc_sort_icon, asc_sort_text, desc_sort_icon, desc_sort_text) do
    case current_order do
      "asc" ->
        case asc_sort_icon do
          nil ->
            """
            <a class="page-link" href="#{url}">#{name} #{asc_sort_text}</a>
            """
          _ ->
            """
            <a class="page-link" href="#{url}">#{name}  <img src=\"#{asc_sort_icon}\" alt=\"#{asc_sort_text}\" title=\"#{asc_sort_text}\" height=\"10\" width=\"10\"></a>
            """
        end

      "desc" ->
        case desc_sort_icon do
          nil ->
            """
            <a class="page-link" href="#{url}">#{name} #{desc_sort_text}</a>
            """
          _ ->
            """
            <a class="page-link" href="#{url}">#{name}  <img src=\"#{desc_sort_icon}\" alt=\"#{desc_sort_text}\" title=\"#{desc_sort_text}\" height=\"10\" width=\"10\"></a>
            """
        end

      _ ->
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

          Regex.match?(~r/^#{field}.asc+$/, current_sort_field) ->
            {"#{field}.desc", "desc"}

          Regex.match?(~r/^#{field}.desc+$/, current_sort_field) ->
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

          Regex.match?(~r/^#{field}.asc+$/, current_sort_field) ->
            {"#{field}.desc", "desc"}

          Regex.match?(~r/^#{field}.desc+$/, current_sort_field) ->
            {"#{field}.asc", "asc"}

          true -> {"#{field}.asc", nil}
        end
    end
  end
end
