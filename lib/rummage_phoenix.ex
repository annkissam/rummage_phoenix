defmodule RummagePhoenix do
  def per_page do
    config(:per_page, "10")
  end

  @doc false
  def config do
    Application.get_env(:rummage_phoenix, RummagePhoenix, [])
  end

  @doc false
  def config(key, default \\ nil) do
    config()
    |> Keyword.get(key, default)
    |> resolve_config(default)
  end

  defp resolve_config({:system, var_name}, default) do
    System.get_env(var_name) || default
  end

  defp resolve_config(value, _default), do: value
end
