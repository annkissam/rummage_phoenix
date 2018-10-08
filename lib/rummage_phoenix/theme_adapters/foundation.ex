defmodule Rummage.Phoenix.Foundation do
  @moduledoc """
  This is the theme adapter for Foundation.
  """

  alias Rummage.Phoenix.PaginateView, as: PView

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
      _link_class(:paginate, page, rummage)
    end
  end

  defp _link_class(:paginate, page, rummage) when page in ~w(first prev)a do
    PView.rummage_pagination_current?(1, rummage) && "disabled" || ""
  end

  defp _link_class(:paginate, page, rummage) when page in ~w(next last)a do
    PView.rummage_pagination_current?(:max, rummage) && "disabled" || ""
  end

  defp _link_class(:paginate, page, rummage) do
    PView.rummage_pagination_current?(page, rummage) && "active" || ""
  end

  def ellipsis do
    Phoenix.HTML.Tag.content_tag :li, [class: "ellipsis", aria_hidden: true] do
    end
  end

  def sort_link(text, href, opts \\ []) do
    class = Keyword.get(opts, :class, "right")
    Phoenix.HTML.Link.link([to: href, class: "#{class}"], do: text)
  end

  def default_text_fn(:paginate) do
    fn(page) ->
      case page do
        :first -> "«"
        :prev -> "⟨"
        :next -> "⟩"
        :last -> "»"
        page -> page
      end
    end
  end

  def default_text_fn(:sort) do
    fn(order) ->
      case order do
        :asc ->
          Phoenix.HTML.Tag.content_tag :i,
            [class: "fi-arrow-down"], do: ""
        :desc ->
          Phoenix.HTML.Tag.content_tag :i,
            [class: "fi-arrow-up"], do: ""
        nil ->
          [Phoenix.HTML.Tag.content_tag(:i,
            [class: "fi-arrow-up"], do: ""),
          Phoenix.HTML.Tag.content_tag(:i,
           [class: "fi-arrow-down"], do: "")]
      end
    end
  end
end
