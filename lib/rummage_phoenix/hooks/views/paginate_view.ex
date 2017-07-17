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
  use Rummage.Phoenix.ThemeAdapter
  import Phoenix.HTML
  alias Rummage.Phoenix.{BootstrapAdapter}

  @doc """
  This macro includes the helper functions for pagination

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
    pagination_links do
      [first_page_link(conn, rummage, opts)] ++
      [previous_page_link(conn, rummage, opts)] ++
      middle_page_links(conn, rummage, opts) ++
      [next_page_link(conn, rummage, opts)] ++
      [last_page_link(conn, rummage, opts)]
      |> Enum.join("\n")
    end
  end

  defp first_page_link(conn, rummage, opts) do
    paginate_params = rummage["paginate"]

    page = String.to_integer(paginate_params["page"] || "1")
    per_page = String.to_integer(paginate_params["per_page"] || "1")
    max_page_links = String.to_integer(paginate_params["max_page_links"] || "4")

    case page - 1 <= (max_page_links / 2) do
      true -> page_link "#", :disabled, do: "First"
      false ->
        page_link index_path(opts, [conn, :index,
          transform_params(rummage, per_page, 1, opts)]), do: "First"
    end
  end

  defp previous_page_link(conn, rummage, opts) do
    paginate_params = rummage["paginate"]

    page = String.to_integer(paginate_params["page"] || "1")
    per_page = String.to_integer(paginate_params["per_page"] || "1")

    case page <= 1 do
      true -> page_link "#", :disabled, do: "Previous"
      false ->
        page_link index_path(opts, [conn, :index,
          transform_params(rummage, per_page, page - 1, opts)]), do: "Previous"
    end
  end

  defp middle_page_links(conn, rummage, opts) do
    paginate_params = rummage["paginate"]

    page = String.to_integer(paginate_params["page"] || "1")
    per_page = String.to_integer(paginate_params["per_page"] || "1")
    max_page = String.to_integer(paginate_params["max_page"] || "1")
    max_page_links = opts[:max_page_links] || Rummage.Phoenix.default_max_page_links

    lower_limit = cond do
      page <= div(max_page_links, 2) -> 1
      page >= (max_page - div(max_page_links, 2)) -> max_page - max_page_links + 1
      true -> page - div(max_page_links, 2)
    end

    upper_limit = lower_limit + max_page_links - 1

    Enum.map(lower_limit..upper_limit, fn(page_num) ->
      cond do
        page == page_num -> page_link "#", :active, do: page_num
        page_num > max_page -> ""
        true ->
          page_link index_path(opts, [conn, :index,
            transform_params(rummage, per_page, page_num, opts)]), do: page_num
      end
    end)
  end

  defp next_page_link(conn, rummage, opts) do
    paginate_params = rummage["paginate"]

    page = String.to_integer(paginate_params["page"] || "1")
    per_page = String.to_integer(paginate_params["per_page"] || "1")
    max_page = String.to_integer(paginate_params["max_page"] || "1")

    case page >= max_page do
      true -> page_link "#", :disabled, do: "Next"
      false ->
        page_link index_path(opts, [conn, :index,
          transform_params(rummage, per_page, page + 1, opts)]), do: "Next"
    end
  end

  defp last_page_link(conn, rummage, opts) do
    paginate_params = rummage["paginate"]

    page = String.to_integer(paginate_params["page"] || "1")
    per_page = String.to_integer(paginate_params["per_page"] || "1")
    max_page_links = String.to_integer(paginate_params["max_page_links"] || "4")
    max_page = String.to_integer(paginate_params["max_page"] || "1")

    case page >= (max_page - max_page_links / 2) do
      true -> page_link "#", :disabled, do: "Last"
      false ->
        page_link index_path(opts, [conn, :index,
          transform_params(rummage, per_page, max_page, opts)]), do: "Last"
    end
  end

  defp transform_params(rummage, per_page, page, opts)
  defp transform_params(rummage, per_page, page, %{slugs: slugs, slugs_params: slugs_params} = opts) do
    rummage = %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> page})}
    slugs ++ Map.merge(rummage, slugs_params)
  end
  defp transform_params(rummage, per_page, page, opts) do
    %{rummage:
        Map.put(rummage, "paginate",
        %{"per_page"=> per_page, "page"=> page})
    }
  end

  defp index_path(opts, params) do
    helpers = opts[:helpers]
    path_function_name = String.to_atom("#{opts[:struct]}_path")

    apply(helpers, path_function_name, params)
  end

  defp per_page(pagination_params) do
    per_page = paginate_params["per_page"]
      |> (&(is_nil(&1) && Rummage.Phoenix.default_per_page || String.to_integer(&1))).()
  end
end
