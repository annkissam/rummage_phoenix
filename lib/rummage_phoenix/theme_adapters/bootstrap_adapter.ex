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
end
