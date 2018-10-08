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

  alias Rummage.Phoenix.Config

  def pagination_links(base_url, rummage, opts \\ []) do
    css = Keyword.get(opts, :css, Config.css())
    _pagination_links(base_url, rummage, css, opts)
  end

  defp _pagination_links(base_url, rummage, css, opts) do
    {max_pagination_links, slugs} = get_defaults(opts)

    href = &rummage_pagination_href(&1, base_url, rummage, slugs)
    link_class_fn = Keyword.get(opts, :link_class_fn,
                             css.link_class_fn(:paginate, rummage))

    text_fn = Keyword.get(opts, :text_fn, css.default_text_fn(:paginate))

    css.pagination_links(opts) do
      [
        _page_link(text_fn.(:first), href.(1), css,
                                               class: link_class_fn.(:first)),
        _page_link(text_fn.(:prev), href.(:prev), css,
                                              class: link_class_fn.(:prev)),
        _page_links(max_pagination_links, base_url, rummage, css, opts),
        _page_link(text_fn.(:next), href.(:next), css,
                                              class: link_class_fn.(:next)),
        _page_link(text_fn.(:last), href.(:last), css,
                                              class: link_class_fn.(:last)),
      ]
      |> List.flatten()
      |> Enum.filter(& &1)
    end
  end

  defp get_defaults(opts) do
    max_pagination_links = Keyword.get(opts, :max_pagination_links,
                                       Config.max_pagination_links())
    slugs = Keyword.get(opts, :slugs, %{})

    {max_pagination_links, slugs}
  end

  def page_link(text, href, opts \\ []) do
    css = Keyword.get(opts, :css, Config.css())
    _page_link(text, href, css, opts)
  end

  defp _page_link(text, href, css, opts) do
    css.page_link(text, href, opts)
  end

  def page_links(max_pagination_links, base_url, rummage, opts \\ []) do
    css = Keyword.get(opts, :css, Config.css())
    _page_links(max_pagination_links, base_url, rummage, css, opts)
  end

  defp _page_links(max_pagination_links, base_url, rummage, css, opts) do
    case max_pagination_links < rummage.paginate.max_page do
      false -> _get_page_links(:all, base_url, rummage, css, opts)
      _ -> _get_page_links(:max, base_url, rummage, css, opts)
    end
  end

  defp _get_page_links(page_nums, base_url, rummage, css, opts)
  defp _get_page_links(:all, base_url, rummage, css, opts) do
    _get_page_links(1..rummage.paginate.max_page, base_url, rummage, css, opts)
  end
  defp _get_page_links(:max, base_url, rummage, css, opts) do
    {max_pagination_links, _slugs} = get_defaults(opts)
    before_pages = 1..div(max_pagination_links, 2) |> Enum.to_list()
    after_pages = (div(max_pagination_links, 2) - 1)..0
                  |> Enum.map(fn(x) -> rummage.paginate.max_page - x end)
    show_pages = before_pages ++ after_pages

    link_class_fn = Keyword.get(opts, :link_class_fn,
                             css.link_class_fn(:paginate, rummage))

    page_links = [_get_page_links(before_pages, base_url, rummage, css, opts)]

    page = rummage.paginate.page

    if page in show_pages do
      if max_pagination_links != rummage.paginate.max_page do
        page_links = page_links ++ [css.ellipsis]
      end
    else
      if max_pagination_links != rummage.paginate.max_page do
        page_links = page_links ++ [css.ellipsis]
      end

      page_links = page_links ++
        [_get_page_links([page], base_url, rummage, css, opts)]

      if max_pagination_links != rummage.paginate.max_page do
        page_links = page_links ++ [css.ellipsis]
      end
    end

    page_links ++ [_get_page_links(after_pages, base_url, rummage, css, opts)]
  end
  defp _get_page_links(pages, base_url, rummage, css, opts) do
    {_max_pagination_links, slugs} = get_defaults(opts)
    href = &rummage_pagination_href(&1, base_url, rummage, slugs)
    link_class_fn = Keyword.get(opts, :link_class_fn,
                               css.link_class_fn(:paginate, rummage))
    text_fn = Keyword.get(opts, :text_fn, css.default_text_fn(:paginate))

    pages
    |> Enum.map(&text_fn.(&1))
    |> Enum.map(&_page_link(&1, href.(&1), css, class: link_class_fn.(&1)))
  end

  def rummage_pagination_href(page \\ 1, base_url, rummage, slugs \\ %{})
  def rummage_pagination_href(:next, base_url, rummage, slugs) do
    paginate = rummage.paginate
    max_page = paginate.max_page
    page = paginate.page

    page = case max_page do
      nil -> page + 1
      max_page when page >= max_page -> page
      _ -> page + 1
    end

    rummage_pagination_href(page, base_url, rummage, slugs)
  end

  def rummage_pagination_href(:prev, base_url, rummage, slugs) do
    paginate = rummage.paginate
    max_page = paginate.max_page
    page = paginate.page

    page = case max_page do
      nil -> page - 1
      max_page when page <= 1 -> page
      _ -> page - 1
    end

    rummage_pagination_href(page, base_url, rummage, slugs)
  end

  def rummage_pagination_href(:last, base_url, rummage, slugs) do
    paginate = rummage.paginate
    max_page = paginate.max_page

    rummage_pagination_href(max_page, base_url, rummage, slugs)
  end

  def rummage_pagination_href(page, base_url, rummage, slugs) do
    paginate = rummage.paginate

    new_rummage = %{rummage | paginate: %{paginate | page: page}}
    params = slugs
      |> Map.merge(%{rummage: new_rummage})
      |> Plug.Conn.Query.encode()

    base_url <> "?" <> params
  end

  def rummage_pagination_current?(:max, rummage) do
    rummage.paginate.page == rummage.paginate.max_page
  end

  def rummage_pagination_current?(page, rummage) do
    rummage.paginate.page == page
  end
end
