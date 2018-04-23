defmodule Rummage.Phoenix.BootstrapAdapter do
  defmacro pagination_links(do: expression) do
    quote do
      Phoenix.HTML.Tag.content_tag :nav, ["aria-lablel": "..."] do
        Phoenix.HTML.Tag.content_tag :ul, [class: "pagination"] do
          unquote(expression)
        end
      end
    end
  end

  defmacro page_link(url, :disabled, do: text) do
    quote do
      Phoenix.HTML.Tag.content_tag :li, [class: "page-item disabled"] do
        Phoenix.HTML.Link.link [to: unquote(url), class: "page-link", tabindex: -1] do
          unquote(text)
        end
      end
    end
  end

  defmacro page_link(url, :active, do: text) do
    quote do
      Phoenix.HTML.Tag.content_tag :li, [class: "page-item active"] do
        Phoenix.HTML.Link.link [to: unquote(url), class: "page-link"] do
          [
            Phoenix.HTML.html_escape(unquote(text)),
            Phoenix.HTML.Tag.content_tag :span, [class: "sr-only"] do
              "(current)"
            end
          ]
        end
      end
    end
  end

  defmacro page_link(url, do: text) do
    quote do
      Phoenix.HTML.Tag.content_tag :li, [class: "page-item"] do
        Phoenix.HTML.Link.link [to: unquote(url), class: "page-link"] do
          unquote(text)
        end
      end
    end
  end

  defmacro sort_text(url, do: html) do
    quote do
      raw """
      <a class="page-link" href="#{unquote(url)}">
        #{unquote(html)}
      </a>
      """
    end
  end

  def sort_text_or_image(url, opts, name) do
    base = """
    <a class="page-link" href="#{url}">
    #{name}
    """

    name = cond do
      opts[:img] ->
        """
        <img src="#{opts[:img]}"
        height="#{opts[:img_ht] || 10}" width="#{opts[:img_wd] || 10}">
        </a>
        """
      opts[:text] ->
        "#{opts[:text]} </a>"
      true -> "</a>"
    end

    Phoenix.HTML.raw(base <> name)
  end
end
