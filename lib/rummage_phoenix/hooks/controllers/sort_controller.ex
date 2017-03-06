defmodule Rummage.Phoenix.SortController do
  @moduledoc """
  `SortController` a controller helper in `Rummage.Phoenix` which stores
  helpers for Sort hook in `Rummage`. This formats params before `index`
  action into a format that is expected by the default `Rummage.Ecto`'s sort
  hook: `Rummage.Ecto.Sort`
  ```
  """

  @doc """
  This function formats params into `rumamge` params, that are expected by
  `Rummage.Ecto`'s default sort hook:

  ## Examples
  When `rummage` passed is an empty `Map`, it returns
  and empty `Map`:
      iex> alias Rummage.Phoenix.SortController
      iex> rummage = %{}
      iex> SortController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  doesn't have a `"sort"` key, it returns
  and empty `Map`:
      iex> alias Rummage.Phoenix.SortController
      iex> rummage = %{"pizza" => "eat"}
      iex> SortController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"sort"` key is an empty `String`,
  it returns and empty `Map`:
      iex> alias Rummage.Phoenix.SortController
      iex> rummage = %{"sort" => ""}
      iex> SortController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"sort"` key is a non-empty `String`,
  it decodes the value returns it:
      iex> alias Rummage.Phoenix.SortController
      iex> rummage = %{"sort" => "1"}
      iex> SortController.rummage(rummage)
      1

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"sort"` key is a `Map`,
  it returns the `Map` itself:
      iex> alias Rummage.Phoenix.SortController
      iex> rummage = %{"sort" => %{"h" => "i"}}
      iex> SortController.rummage(rummage)
      %{"h" => "i"}
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
