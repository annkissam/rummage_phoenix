defmodule Rummage.Phoenix.ViewResolver do
  def make_helpers_name_from_topmost_namespace(view_module) do
    "#{view_module}"
    |> String.split(".")
    |> Enum.at(1)
    |> (& "Elixir." <> &1 <> ".Router.Helpers").()
    |> String.to_atom
  end

  def make_struct_name_from_bottommost_namespace(view_module) do
    "#{view_module}"
    |> String.split(".")
    |> Enum.at(-1)
    |> String.split("View")
    |> Enum.at(0)
    |> String.downcase
    |> String.to_atom
  end
end
