defmodule Rummage.Phoenix.Bootstrap3Min do
  @moduledoc """
  This is the theme adapter for Bootstrap 3 Minimal, which comes shipped with
  Phoenix.
  """

  use Rummage.Phoenix.ThemeAdapter

  def pagination_links(do: expression) do
    Phoenix.HTML.Tag.content_tag :nav, ["aria-lablel": "..."] do
      Phoenix.HTML.Tag.content_tag :ul, [class: "pagination"], do: expression
    end
  end

  def page_link(url, :disabled, do: text) do
    Phoenix.HTML.Tag.content_tag :li, [class: "page-item disabled"] do
      Phoenix.HTML.Link.link [to: url, class: "page-link", tabindex: -1], do: text
    end
  end

  def page_link(url, :active, do: text) do
    Phoenix.HTML.Tag.content_tag :li, [class: "page-item active"] do
      Phoenix.HTML.Link.link [to: url, class: "page-link"] do
        [
          Phoenix.HTML.html_escape(text),
          Phoenix.HTML.Tag.content_tag(:span, [class: "sr-only"], do: "(current)")
        ]
      end
    end
  end

  def page_link(url, do: text) do
    Phoenix.HTML.Tag.content_tag :li, [class: "page-item"] do
      Phoenix.HTML.Link.link [to: url, class: "page-link"], do: text
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
