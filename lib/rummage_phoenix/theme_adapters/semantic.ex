defmodule Rummage.Phoenix.Semantic do
  @moduledoc """
  This is the theme adapter for Semantic.
  """

  use Rummage.Phoenix.ThemeAdapter

  alias Rummage.Phoenix.PaginateView, as: PView

  def pagination_links(opts, do: expression) do
    Phoenix.HTML.Tag.content_tag :div, [role: "navigation",
      class: "ui pagination menu"], do: expression
  end

  def page_link(text, href, opts) do
    class = Keyword.get(opts, :class, "")
    tabindex = Keyword.get(opts, :tabindex, -1)

    Phoenix.HTML.Link.link([to: href, class: "item #{class}",
      tabindex: tabindex], do: text)
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
    page_link("...", "#", class: "disabled")
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
          Phoenix.HTML.Tag.content_tag :i, [class: "caret down icon"], do: ""
        :desc ->
          Phoenix.HTML.Tag.content_tag :i, [class: "caret up icon"], do: ""
        nil ->
          Phoenix.HTML.Tag.content_tag :i, [class: "sort icon"], do: ""
      end
    end
  end
end
