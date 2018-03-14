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
  <%= sort_link @conn, @rummage, field, "Name" %>
  ```
  """
  def sort_link(conn, rummage, field, name, opts) do
    sort_params = rummage.sort

    asc_icon = Keyword.get(opts, :asc_icon)
    asc_text = Keyword.get(opts, :asc_text, "↑")
    desc_icon = Keyword.get(opts, :desc_icon)
    desc_text = Keyword.get(opts, :desc_text, "↓")

    text = if sort_params.name == Atom.to_string(field) do
      case sort_params.order do
        "asc" ->
          rummage_params = rummage.params
          |> Map.drop([:paginate])
          |> Map.put(:sort, %{name: field, order: "desc"})

          url = index_path(opts, [conn, :index, %{rummage: rummage_params}])
          sort_text_or_image(url, [img: desc_icon, text: desc_text], name)
        "desc" ->
          rummage_params = rummage.params
          |> Map.drop([:paginate])
          |> Map.put(:sort, %{name: field, order: "asc"})

          url = index_path(opts, [conn, :index, %{rummage: rummage_params}])
          sort_text_or_image(url, [img: asc_icon, text: asc_text], name)
      end
    else
      rummage_params = rummage.params
      |> Map.drop([:paginate])
      |> Map.put(:sort, %{name: field, order: "asc"})

      url = index_path(opts, [conn, :index, %{rummage: rummage_params}])
      sort_text_or_image(url, [], name)
    end
  end

  defp index_path(opts, params) do
    helpers = opts[:helpers]
    path_function_name = String.to_atom("#{opts[:struct]}_path")

    apply(helpers, path_function_name, params)
  end
end
