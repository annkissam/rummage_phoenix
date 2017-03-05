defmodule Rummage.Phoenix.PaginateController do
  @moduledoc """
  Paginate Controller Module for Rummage. This builds rummage params and performs search action

  Usage:

   ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helper: MyApp.Router.Helpers
  end
  ```
  """

  @doc """
  This macro includes the helper functions from different Rummage.Phoenix.PaginateController.
  It defines a `search` action which redirects to `index` action
  """
  def rummage(rummage) do
    paginate_params = Map.get(rummage, "paginate")
    case paginate_params do
      s when s in ["", nil] -> %{}
      s when is_binary(s) ->
        paginate_params
        |> Poison.decode!
      _ -> paginate_params
    end
  end
end
