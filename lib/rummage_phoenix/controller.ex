defmodule Rummage.Phoenix.Controller do
  @moduledoc """
  Controller Module for Rummage.Phoenix. This builds rummage params and performs search action

  Usage:


  """

  defmacro __using__(opts) do
    rummage_ecto_app = Keyword.get(opts, :rummage_ecto_app, nil)
    schema = Keyword.get(opts, :rummage_schema, nil)

    quote do
      @doc false
      def rummage_params(nil), do: rummage_params(%{})
      def rummage_params(%{} = rummage_params) do
        unquote(__MODULE__).rummage_params(rummage_params,
                                           rummage_ecto_app,
                                           unquote(schema))
      end

      defp rummage_ecto_app do
        case unquote(rummage_ecto_app) do
          nil -> Application.get_application(__MODULE__)
          app -> app
        end
      end
    end
  end

  @doc false
  def rummage_params(%{} = rummage_params, rummage_ecto_app, rummage_schema) do
    Enum.reduce(~w{search sort paginate}, %{}, fn(key, acc) ->
      case Map.get(rummage_params, key) do
        nil ->
          __get_default_params__(key, acc, rummage_ecto_app, rummage_schema)
        value ->
          Map.put(acc, :"#{key}",
                  apply(__MODULE__,
                                :"__format_#{key}_params__",
                                [value]))
      end
    end)
  end

  @doc false
  defp __get_default_params__(key, acc, rummage_ecto_app, schema) do
    case function_exported?(Rummage.Phoenix.Controller,
                            :"__get_default_#{key}_params__", 2) do
      true ->
        Map.put(acc,
                :"#{key}",
                apply(Rummage.Phoenix.Controller,
                      :"__get_default_#{key}_params__",
                      [rummage_ecto_app, schema]))
      false -> acc
    end
  end

  @doc false
  def __format_search_params__(params) do
    params
    |> Map.to_list()
    |> Enum.map(&atomify/1)
    |> Enum.into(%{})
  end

  @doc false
  def __format_sort_params__(params) do
    params
    |> Map.to_list()
    |> Enum.map(&atomify/1)
    |> Enum.into(%{})
  end

  defp atomify({"assoc", v}), do: atomify({:assoc, v})
  defp atomify({"search_term", v}), do: {:search_term, v}
  defp atomify({k, "true"}), do: {:"#{k}", true}
  defp atomify({k, "false"}), do: {:"#{k}", false}
  defp atomify({k, v}) when is_map(v) do
    {:"#{k}", v |> Map.to_list() |> Enum.map(&atomify/1) |> Enum.into(%{})}
  end
  defp atomify({k, v}), do: {:"#{k}", :"#{v}"}

  @doc false
  def __format_paginate_params__(params) do
    Enum.reduce(~w{per_page page}, %{}, fn(key, acc) ->
      case Map.get(params, key) do
        nil -> acc
        value -> Map.put(acc, :"#{key}", String.to_integer(value))
      end
    end)
  end

  @doc false
  def __get_default_paginate_params__(rummage_ecto_app, rummage_schema) do
    per_page =
      with nil <- rummage_schema,
           app when not is_nil(app) <- rummage_ecto_app
      do
        Rummage.Ecto.Config.per_page(app)
      else
        schema when not is_nil(schema) -> schema.__rummage_defaults__[:per_page]
        nil -> Rummage.Ecto.Config.per_page
      end


    %{per_page: per_page, page: 1}
  end
end
