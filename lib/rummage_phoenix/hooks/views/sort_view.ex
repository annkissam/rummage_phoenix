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
  <%= sort_link @conn, @rummage, field, "Name" %>
  <%= sort_link @conn, {@rummage, :rummage_key}, field, "Name" %>
  ```
  """

  alias Rummage.Phoenix.Config

  def sort_link(field, base_url, rummage, opts \\ []) do
    css = Keyword.get(opts, :css, Config.css())
    _sort_link(field, base_url, rummage, css, opts)
  end

  defp _sort_link(field, base_url, rummage, css, opts) do
    {slugs, show, ci} = get_defaults(opts)

    case show do
      [] ->
        _get_sort_link(:alt, field, base_url, rummage, css, opts)
      links ->
        links
        |> Enum.map(&_get_sort_link(&1, field, base_url, rummage, css, opts))
    end
  end

  def get_sort_link(order, field, base_url, rummage, opts \\ []) do
    css = Keyword.get(opts, :css, Config.css())
    _get_sort_link(order, field, base_url, rummage, css, opts)
  end

  defp _get_sort_link(:alt, field, base_url, rummage, css, opts) do
    order = rummage_sort_get_order(field, rummage)
    _get_sort_link(order, field, base_url, rummage, css, opts)
  end

  defp _get_sort_link(order, field, base_url, rummage, css, opts) do
    href = rummage_sort_href(order, field, base_url, rummage, opts)
    text_fn = Keyword.get(opts, :text_fn, css.default_text_fn(:sort))

    css.sort_link(text_fn.(order), href, opts)
  end

  def rummage_sort_get_order(%{scope: scope, type: type, schema: schema}, rummage) do
    test = rummage_sort_get_order(_get_sort_scope_params(schema, type, scope), rummage)
  end

  defp _get_sort_scope_params(schema, type, scope) do
    schema
    |> apply(:"__rummage_#{type}_#{scope}", [:asc])
    |> Map.drop([:order])
  end

  def rummage_sort_get_order(map = %{field: field, assoc: assoc}, rummage) do
    ci = Map.get(map, :ci, false)
    sort = Map.get(rummage, :sort, %{})
    with false <- Map.equal?(sort, %{}),
         true <- (Map.get(sort, :field, nil) == field),
         true <- (Map.get(sort, :assoc, []) == assoc),
         true <- (Map.get(sort, :ci, false) == ci),
         :asc <- Map.get(sort, :order, :asc)
    do
      :desc
    else
      :desc -> :asc
      _ -> nil
    end
  end

  def rummage_sort_get_order(map = %{field: field}, rummage) do
    map
    |> Map.put(:assoc, [])
    |> rummage_sort_get_order(rummage)
  end

  defp get_defaults(opts) do
    slugs = Keyword.get(opts, :slugs, %{})
    show = Keyword.get(opts, :show, [])
    ci = Keyword.get(opts, :ci, false)

    {slugs, show, ci}
  end

  def rummage_sort_href(order, field, base_url, rummage, opts) do
    {slugs, _show, ci} = get_defaults(opts)
    order = order || :asc

    params = slugs
      |> Map.merge(%{rummage: _new_rummage(order, field, rummage, ci)})
      |> Plug.Conn.Query.encode()

    base_url <> "?" <> params
  end

  defp _new_rummage(order, %{scope: scope}, rummage, ci) do
    order = order || :asc

    sort = Map.get(rummage, :sort, %{})

    case Map.equal?(sort, %{}) do
      true -> Map.put(rummage, :sort, %{scope: scope, order: order, ci: ci})
      _ -> %{rummage | sort: %{scope: scope, order: order, ci: ci}}
    end
  end

  defp _new_rummage(order, %{field: field, assoc: assoc}, rummage, ci) do
    order = order || :asc

    sort = Map.get(rummage, :sort, %{})

    case Map.equal?(sort, %{}) do
      true ->
        Map.put(rummage, :sort, %{field: field, assoc: assoc,
          order: order, ci: ci})
      _ ->
        %{rummage | sort: %{field: field, assoc: assoc, order: order, ci: ci}}
    end
  end

  defp _new_rummage(order, %{field: field}, rummage, ci) do
    order = order || :asc

    sort = Map.get(rummage, :sort, %{})

    case Map.equal?(sort, %{}) do
      true ->
        Map.put(rummage, :sort, %{field: field, order: order, ci: ci})
      _ -> %{rummage | sort: %{field: field, order: order, ci: ci}}
    end
  end
end
