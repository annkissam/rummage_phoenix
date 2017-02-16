defmodule RummagePhoenix.PaginateView do
  @moduledoc """
  View Helper for Pagination in Rummage for bootstrap views.
  """

  defmacro __using__(opts) do
    quote do
      def pagination_link(conn, rummage, query \\ unquote(opts[:default_scope])) do
        pagiante_params = rummage["paginate"]

        total_count = String.to_integer(pagiante_params["total_count"] || "1")

        per_page = String.to_integer(pagiante_params["per_page"] || RummagePhoenix.per_page)
        page = String.to_integer(pagiante_params["page"] || "1")
        max_page = String.to_integer(pagiante_params["max_page"] || "1")

        if max_page > 1 do
          raw_links = cond do
            page <= 1 ->
              [raw_disabled_link("Previous")]
            true ->
              [raw_link("Previous", apply(unquote(opts[:helper]),
                String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> page - 1})}]))]
          end

          raw_links = raw_links ++ Enum.map(1..max_page, fn(x) ->
            case page == x do
              true -> raw_active_link(x)
              _-> raw_link(x, apply(unquote(opts[:helper]),
                String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> x})}]))
            end
          end)

          raw_links = raw_links ++ cond do
            page == max_page ->
              [raw_disabled_link("Next")]
            true ->
              [raw_link("Next", apply(unquote(opts[:helper]),
                String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, %{rummage: Map.put(rummage, "paginate", %{"per_page"=> per_page, "page"=> page + 1})}]))]
          end

          raw """
          <nav aria-label="...">
          <ul class="pagination">
            #{Enum.join(raw_links, "\n")}
          </ul>
          </nav>
          """
        else
          ""
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

      defp search_module do
        unquote(opts[:search]) || Rummage.Ecto.Config.default_search
      end
    end
  end
end
