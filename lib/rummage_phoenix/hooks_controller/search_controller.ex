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
  def rummage(rummage) do
    search_params = Map.get(rummage, "search")
    case search_params do
      nil -> %{}
      _ ->
        search_params = search_params
        |> Map.to_list
        |> Enum.map(&change_assoc_to_a_one_member_list &1)
        |> Enum.reject(fn(x) -> elem(x, 1) == "" end)
        |> Enum.into(%{})

        search_params
    end
  end

  # This is temporary until we figure out how to add multiple assoc to a form
  defp change_assoc_to_a_one_member_list({field, params}) do
    case params["assoc"] do
      nil -> {field, Map.put(params, "assoc", [])}
      assoc when assoc == "" -> {field, Map.put(params, "assoc", [])}
      assoc when is_binary(assoc) -> {field, Map.put(params, "assoc", [assoc])}
      _ -> {field, params}
    end
  end
end
