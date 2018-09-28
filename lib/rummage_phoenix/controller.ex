defmodule Rummage.Phoenix.Controller do
  @moduledoc """
  Controller Module for Rummage.Phoenix. This builds rummage params and performs search action

  Usage:


  """

  defmacro __using__(opts) do
    rummage_ecto_app = Keyword.get(opts, :rummage_ecto_app, nil)

    quote do
      import unquote(__MODULE__)

      @doc false
      def rummage_params(nil), do: rummage_params(%{})
      def rummage_params(%{} = rummage_params) do
        Enum.reduce(~w{search sort paginate}, %{}, fn(key, acc) ->
          case Map.get(rummage_params, key) do
            nil -> __call_fn__(key, acc)
            value ->
              Map.put(acc,
                      :"#{key}",
                      apply(unquote(__MODULE__), :"__rummage_#{key}_params__", [value]))
          end
        end)
      end

      defp __call_fn__(key, acc) do
        case function_exported?(__MODULE__, :"__rummage_default_#{key}_params__", 0) do
          true ->
            Map.put(acc,
                    :"#{key}",
                    apply(__MODULE__, :"__rummage_default_#{key}_params__", []))
          false -> acc
        end
      end

      @doc false
      def __rummage_default_paginate_params__ do
        per_page = case unquote(rummage_ecto_app) do
          nil -> Rummage.Ecto.Config.per_page
          app -> Rummage.Ecto.Config.per_page(app)
        end

        %{per_page: per_page, page: 1}
      end
    end
  end

  @doc false
  def __rummage_search_params__(params) do
    params
    |> Map.to_list()
    |> Enum.map(&__rummage_format_search_param__/1)
    |> Enum.into(%{})
  end

  defp __rummage_format_search_param__({key, val = %{}}) do
    val = val
      |> Map.to_list()
      |> Enum.map(fn {k, v} ->
        k == "search_term" && {:"#{k}", v} || {:"#{k}", :"#{v}"}
      end)
      |> Enum.into(%{})

    {:"#{key}", val}
  end

  defp __rummage_format_search_param__({key, val}) do
    {:"#{key}", val}
  end

  @doc false
  def __rummage_sort_params__(params) do
    params
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {:"#{k}", :"#{v}"} end)
    |> Enum.into(%{})
  end

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
