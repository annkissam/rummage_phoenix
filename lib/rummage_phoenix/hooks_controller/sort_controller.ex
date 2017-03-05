defmodule Rummage.Phoenix.SortController do
  @moduledoc """
  Sort Controller Module for Rummage. This builds rummage params and performs search action

  Usage:

   ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helper: MyApp.Router.Helpers
  end
  ```
  """

  @doc """
  This macro includes the helper functions from different Rummage.Phoenix.SortController.
  It defines a `search` action which redirects to `index` action
  """
  def rummage(rummage) do
    sort_params = Map.get(rummage, "sort")
    case sort_params do
      s when s in ["", nil] -> %{}
      s when is_binary(s) ->
        sort_params
        |> Poison.decode!
      _ -> sort_params
    end
  end
end
