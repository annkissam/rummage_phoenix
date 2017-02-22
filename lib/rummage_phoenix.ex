defmodule Rummage.Phoenix do
  @moduledoc """
  `Rummage.Phoenix` is a support framework for `Phoenix` that can be used to manipulate
  `Phoenix` collections and `Ecto` models with Search, Sort and Paginate operations.

  It accomplishes the above operations by using `Rummage.Ecto`, to paginate `Ecto`
  queries and adds Phoenix and HTML support to views and controllers.
  Each operation: Search, Sort and Paginate have their hooks defined in `Rummage.Ecto`
  and is configurable.

  The best part about rummage is that all the three operations: `Search`, `Sort` and
  `Paginate` integrate seamlessly and can be configured separately. To check out their
  seamless integration, please check the information below.

  If you want to check a sample application that uses Rummage, please check
  [this link](https://github.com/Excipients/rummage_phoenix_example).
  """

  @doc false
  def per_page do
    config(:per_page, "10")
  end

  @doc false
  def config do
    Application.get_env(:rummage_phoenix, Rummage.Phoenix, [])
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
