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

  use Rummage.Phoenix.ThemeAdapter
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
  def sort_link(conn, rummage, opts \\ []) do
    current_sort_params = rummage["sort"]

    field = Keyword.fetch!(opts, :field)
    asc_icon = Keyword.get(opts, :asc_icon)
    asc_text = Keyword.get(opts, :asc_text, "↑")
    desc_icon = Keyword.get(opts, :desc_icon)
    desc_text = Keyword.get(opts, :desc_text, "↓")

    name = opts[:name] || Phoenix.Naming.humanize(field)
    assoc = opts[:assoc] || []

    {sort_field, current_order} = get_sort_field_and_current_order(current_sort_params, field, assoc)

    sort_field = opts[:ci] && sort_field <> ".ci" || sort_field

    sort_params = %{"assoc" => assoc, "field" => sort_field}

    url = index_path(opts, [conn, :index, %{rummage: Map.put(rummage, "sort", sort_params)}])

    text = case current_order do
      "asc" -> sort_text_or_image(url, [img: desc_icon, text: desc_text], name)
      "desc" -> sort_text_or_image(url, [img: asc_icon, text: asc_text], name)
      _ -> sort_text_or_image(url, [], name)
    end

    sort_text url, do: text
  end

  defp index_path(opts, params) do
    helpers = opts[:helpers]
    path_function_name = String.to_atom("#{opts[:struct]}_path")

    apply(helpers, path_function_name, params)
  end

  defp get_sort_field_and_current_order(current_sort_params, field, assoc)
  defp get_sort_field_and_current_order(c, field, _) when c in [nil, "", [], %{}], do: {"#{field}.asc", nil}
  defp get_sort_field_and_current_order(%{"assoc" => current_assoc, "field" => current_field}, field, assoc) do
    current_sort_field = current_field
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
  defp get_sort_field_and_current_order(%{"field" => current_field}, field, assoc) do
    current_sort_field = current_field
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
  end
end
