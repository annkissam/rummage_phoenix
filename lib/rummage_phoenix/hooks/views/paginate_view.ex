defmodule Rummage.Phoenix.PaginateView do
  @moduledoc """
  View Helper for Pagination in Rummage for bootstrap views.

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

  import Rummage.Phoenix.ViewResolver
  import Phoenix.HTML

  @doc """
  This macro includes the helpers functions for pagination

  Provides helper functions `pagination_link/3` for creating pagination links in an html.eex
  file of using `Phoenix`.

  Usage:
  Just add the following code in the index template. Make sure that you're passing
  rummage from the controller. Please look at the
  [README](https://github.com/Excipients/rummage_phoenix) for more details

  ```elixir
  pagination_link(@conn, @rummage)
  ```
  """
  def pagination_link(conn, rummage, opts \\ []) do
    paginate_params = rummage["paginate"]

    per_page = paginate_params["per_page"]
      |> (fn(x) -> is_nil(x) && Rummage.Phoenix.default_per_page || String.to_integer(x) end).()


    page = String.to_integer(paginate_params["page"] || "1")
    max_page = String.to_integer(paginate_params["max_page"] || "1")

    if max_page > 1 do
      raw """
      <nav aria-label="...">
      <ul class="pagination">
        #{conn |> get_raw_links(rummage, per_page, page, max_page, opts) |> Enum.join("\n")}
      </ul>
      </nav>
      """
    else
      ""
    end
  end

  defp get_raw_links(conn, rummage, per_page, page, max_page, opts) do
    slugs = opts[:slugs] || nil
    slug_params = opts[:slug_params] || nil

    raw_links = cond do
      page <= 1 ->
        [raw_disabled_link("Previous")]
      slugs && slug_params ->
        [raw_link("Previous", apply(opts[:helpers] || Rummage.Phoenix.default_helpers,
          String.to_atom("#{opts[:struct]}_path"), get_helper_params(conn, slugs, slug_params, rummage, per_page, page - 1)))]
      true ->
        [raw_link("Previous", apply(opts[:helpers] || Rummage.Phoenix.default_helpers,
          String.to_atom("#{opts[:struct]}_path"), [conn, :index, %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> page - 1})}]))]
    end

    raw_links = raw_links ++ Enum.map(1..max_page, fn(x) ->
      case page == x do
        true ->
          raw_active_link(x)
        _ ->
          cond do
            slugs && slug_params ->
              raw_link(x, apply(opts[:helpers] || Rummage.Phoenix.default_helpers,
                String.to_atom("#{opts[:struct]}_path"), get_helper_params(conn, slugs, slug_params, rummage, per_page, x)))
            true ->
              raw_link(x, apply(opts[:helpers] || Rummage.Phoenix.default_helpers,
                String.to_atom("#{opts[:struct]}_path"), [conn, :index, %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> x})}]))
          end
      end
    end)

    raw_links ++ cond do
      page == max_page ->
        [raw_disabled_link("Next")]
      slugs && slug_params ->
        [raw_link("Next", apply(opts[:helpers] || Rummage.Phoenix.default_helpers,
          String.to_atom("#{opts[:struct]}_path"), get_helper_params(conn, slugs, slug_params, rummage, per_page, page + 1)))]
      true ->
        [raw_link("Next", apply(opts[:helpers] || Rummage.Phoenix.default_helpers,
          String.to_atom("#{opts[:struct]}_path"), [conn, :index, %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> page + 1})}]))]
    end
  end

  defp raw_disabled_link(name) do
    """
    <li class="page-item disabled">
      <a class="page-link" href="#" tabindex="-1">#{name}</a>
    </li>
    """
  end

  defp raw_link(name, url) do
    """
    <li class="page-item">
      <a class="page-link" href="#{url}">#{name}</a>
    </li>
    """
  end

  defp raw_active_link(name) do
    """
    <li class="page-item active">
      <a class="page-link" href="#">#{name} <span class="sr-only">(current)</span></a>
    </li>
    """
  end

  defp get_helper_params(conn, slugs, slug_params, rummage, per_page, page) do
    slugged = [conn, :index | slugs]
    rummage_page = %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> page})}
    full_params = Map.merge(rummage_page, slug_params)
    helper_params_splat = slugged ++ [full_params]
  end
end
