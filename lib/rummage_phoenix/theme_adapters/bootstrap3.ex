defmodule Rummage.Phoenix.Bootstrap3 do
  @moduledoc """
  This is the theme adapter for Bootstrap 3.
  """

  import Rummage.Phoenix.PaginateView

  def pagination_links(opts, do: expression) do
    Phoenix.HTML.Tag.content_tag :ul, [class: "pagination"], do: expression
  end

  def page_link(text, href, opts) do
    class = Keyword.get(opts, :class, "")
    tabindex = Keyword.get(opts, :tabindex, -1)

    Phoenix.HTML.Tag.content_tag :li, [class: "page-item #{class}"] do
      Phoenix.HTML.Link.link([to: href, class: "page-link", tabindex: tabindex],
                             do: text)
    end
  end

  def link_class_fn(:paginate, rummage) do
    fn(page) ->
      case page do
        page when page in ~w(first prev)a ->
          rummage_pagination_current?(1, rummage) && "disabled" || ""
        page when page in ~w(next last)a ->
          rummage_pagination_current?(:max, rummage) && "disabled" || ""
        nil -> "disabled"
        page ->
          rummage_pagination_current?(page, rummage) && "active" || ""
      end
    end
  end

  def sort_link(url, do: html, content_tag: content_tag, class: class) do
    Phoenix.HTML.Tag.content_tag content_tag, [class: class, href: url], do: html
  end

  def sort_link(url, opts \\ []) do
    sort_link(url, do: Keyword.fetch!(opts, :do),
                   content_tag: Keyword.get(opts, :content_tag, :a),
                   class: Keyword.get(opts, :class, "page-link"))
  end
end
