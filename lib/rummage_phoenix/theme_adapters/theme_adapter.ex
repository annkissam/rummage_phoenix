defmodule Rummage.Phoenix.ThemeAdapter do
  @moduledoc """
  This module defines a behavior that `Rummage.Phoenix.ThemeAdapters` have to follow.
  Custom ThemeAdapters should follow this behavior and implement all the functions
  """
  @callback run(queryable :: Ecto.Query.t, rummage :: map) :: queryable :: Ecto.Query.t
  @callback before_hook(queryable :: Ecto.Query.t, rummage :: map, opts :: map) :: rummage :: map

  defmacro __using__(_) do
    module = theme_adapter()

    quote do
      import unquote(module)
    end
  end

  defp theme_adapter() do
    (Rummage.Phoenix.default_theme || :bootstrap)
    |> Atom.to_string
    |> String.capitalize
    |> (& "Elixir.Rummage.Phoenix." <> &1 <> "Adapter").()
    |> String.to_atom
  end
end
