defmodule Rummage.Phoenix.SearchController do
  @moduledoc """
  `SearchController` a controller helper in `Rummage.Phoenix` which stores
  helpers for Search hook in `Rummage`. This formats params before `index`
  action into a format that is expected by the default `Rummage.Ecto`'s search
  hook: `Rummage.Ecto.Search`
  ```
  """

  @doc """
  This function formats params into `rumamge` params, that are expected by
  `Rummage.Ecto`'s default search hook:

  ## Examples
  When `rummage` passed is an empty `Map`, it returns
  and empty `Map`:
      iex> alias Rummage.Phoenix.SearchController
      iex> rummage = %{}
      iex> SearchController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  doesn't have a `"search"` key, it returns
  and empty `Map`:
      iex> alias Rummage.Phoenix.SearchController
      iex> rummage = %{"pizza" => "eat"}
      iex> SearchController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"search"` key is an empty `String`,
  it returns and empty `Map`:
      iex> alias Rummage.Phoenix.SearchController
      iex> rummage = %{"search" => ""}
      iex> SearchController.rummage(rummage)
      %{}

  When `rummage` passed is not an empty `Map`, but
  the value corresponding to `"search"` key is a `Map`,
  it returns the `Map` itself, with association converted
  to a one element list (This will change in future when `Rumamge.Phoenix`
  will have support for deeper `associations`:
      iex> alias Rummage.Phoenix.SearchController
      iex> rummage = %{"search" => %{"field" => %{"assoc" => "assoc"}}}
      iex> SearchController.rummage(rummage)
      %{"field" => %{"assoc" => ["assoc"]}}
  """
  def rummage(rummage) do
    search_params = Map.get(rummage, "search")
    case search_params do
      s when s in [nil, "", %{}] -> %{}
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
