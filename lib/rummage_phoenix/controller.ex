defmodule Rummage.Phoenix.Controller do
  @moduledoc """
  Controller Module for Rummage.Phoenix. This builds rummage params and performs search action

  Usage:


  """

  @doc false
  def rummage_params(%{} = rummage_params) do
    Enum.reduce(~w{search sort paginate}, %{}, fn(key, acc) ->
      case Map.get(rummage_params, key) do
        nil -> acc
        value -> Map.put(acc, :"#{key}", apply(__MODULE__, :"__rummage_#{key}_params__", [value]))
      end
    end)
  end

  @doc false
  def __rummage_search_params__(p), do: p

  @doc false
  def __rummage_sort_params__(p), do: p

  @doc false
  def __rummage_paginate_params__(params) do
    Enum.reduce(~w{per_page page}, %{}, fn(key, acc) ->
      case Map.get(params, key) do
        nil -> acc
        value -> Map.put(acc, :"#{key}", String.to_integer(value))
      end
    end)
  end
end
