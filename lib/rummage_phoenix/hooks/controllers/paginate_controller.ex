defmodule Rummage.Phoenix.PaginateController do
  @moduledoc """
  `PaginateController` a controller helper in `Rummage.Phoenix` which stores
  helpers for Paginate hook in `Rummage`. This formats params before `index`
  action into a format that is expected by the default `Rummage.Ecto`'s paginate
  hook: `Rummage.Ecto.Paginate`
  ```
  """

  @doc """
  This function formats params into `rumamge` params, that are expected by
  `Rummage.Ecto`'s default paginate hook:

  ## Examples
  When `rummage` passed is an empty `Map`, it returns
  and empty `Map`:
      iex> alias Rummage.Phoenix.PaginateController
      iex> rummage = %{}
      iex> PaginateController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  doesn't have a `"paginate"` key, it returns
  and empty `Map`:
      iex> alias Rummage.Phoenix.PaginateController
      iex> rummage = %{"pizza" => "eat"}
      iex> PaginateController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"paginate"` key is an empty `String`,
  it returns and empty `Map`:
      iex> alias Rummage.Phoenix.PaginateController
      iex> rummage = %{"paginate" => ""}
      iex> PaginateController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"paginate"` key is a non-empty `String`,
  it decodes the value returns it:
      iex> alias Rummage.Phoenix.PaginateController
      iex> rummage = %{"paginate" => "1"}
      iex> PaginateController.rummage(rummage)
      1

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"paginate"` key is a `Map`,
  it returns the `Map` itself:
      iex> alias Rummage.Phoenix.PaginateController
      iex> rummage = %{"paginate" => %{"h" => "i"}}
      iex> PaginateController.rummage(rummage)
      %{"h" => "i"}
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
