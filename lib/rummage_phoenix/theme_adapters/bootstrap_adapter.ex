defmodule Rummage.Phoenix.BootstrapAdapter do
  defmacro pagination_links(do: expression) do
    quote do
      raw """
      <nav aria-label="...">
        <ul class="pagination">
          #{unquote(expression)}
        </ul>
      </nav>
      """
    end
  end

  defmacro page_link(url, :disabled, do: text) do
    quote do
      """
      <li class="page-item disabled">
        <a class="page-link" href="#{unquote(url)}" tabindex="-1">
          #{unquote(text)}
        </a>
      </li>
      """
    end
  end

  defmacro page_link(url, :active, do: text) do
    quote do
      """
      <li class="page-item active">
        <a class="page-link" href="#{unquote(url)}">
          #{unquote(text)}
          <span class="sr-only">
            (current)
          </span>
        </a>
      </li>
      """
    end
  end

  defmacro page_link(url, do: text) do
    quote do
      """
      <li class="page-item">
        <a class="page-link" href="#{unquote(url)}">
          #{unquote(text)}
        </a>
      </li>
      """
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

    base <> name
  end
end
