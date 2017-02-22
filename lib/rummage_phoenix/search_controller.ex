defmodule Rummage.Phoenix.SearchController do
  @moduledoc """
  Search Controller Module for Rummage. This builds rummage params and performs search action

  Usage:

   ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helper: MyApp.Router.Helpers
  end
  ```
  """

  @doc """
  This macro includes the helper functions from different Rummage.Phoenix.SearchController.
  It defines a `search` action which redirects to `index` action
  """
  defmacro __using__(opts) do
    quote do
      def search(conn, params) do
        redirect(conn, to: apply(unquote(opts[:helper]),
          String.to_atom("#{unquote(opts[:struct])}_path"), [conn, :index, rummage_search_params(params)]))
      end

      defp rummage_search_params(params) do
        rummage = Map.get(params, "rummage")

        search_params = Map.drop(rummage, ["sort", "paginate"])
          |> Map.to_list
          |> Enum.reject(fn(x) -> elem(x, 1) == "" end)
          |> Enum.into(%{})

        sort_params = Map.get(rummage, "sort")
        sort_params =
          if sort_params in ["", nil] do
            ""
          else
            sort_params
            |> Poison.decode!
          end

        paginate_params = Map.get(rummage, "paginate")
        paginate_params =
          if paginate_params in ["", nil] do
            %{}
          else
            paginate_params
            |> Poison.decode!
          end

        rummage = %{
          "sort" => sort_params,
          "search" => search_params,
          "paginate" => paginate_params
        }

        Map.put(params, "rummage", rummage)
      end
    end
  end
end
