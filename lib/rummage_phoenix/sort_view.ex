defmodule Rummage.Phoenix.SortView do
  @moduledoc """
  Sort View Module for Rummage. This has view helpers that can generate rummagable links and forms.
  """

  defmacro __using__(opts) do
    quote do
      def sort_link(field, conn, rummage, name \\ nil) do
        current_sort_params = rummage["sort"]
        name = name || Phoenix.Naming.humanize(field)

        {name, sort_params} =
          cond do
            current_sort_params in [nil, "", []] -> {name, "#{field}.asc"}

            Regex.match?(~r/#{field}.asc+$/, current_sort_params) ->
              {name <> " ↓", "#{field}.desc"}

            Regex.match?(~r/#{field}.desc+$/, current_sort_params) ->
              {name <> " ↑", "#{field}.asc"}

            true -> {name, "#{field}.asc"}
          end

        raw link_with_icon(name, apply(unquote(opts[:helper]),
          String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, %{rummage: Map.put(rummage, "sort", sort_params)}]))
      end

      defp link_with_icon(name, url) do
        """
        <a class="page-link" href="#{url}">#{name}</a>
        """
      end
    end
  end
end
