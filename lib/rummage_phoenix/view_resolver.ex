defmodule Rummage.Phoenix.ViewResolver do
  def make_helpers_name_from_topmost_namespace(view_module) do
    "#{view_module}"
    |> String.split(".")
    |> Enum.at(1)
    |> helpers_module
  end

  def make_struct_name_from_bottommost_namespace(view_module) do
    "#{view_module}"
    |> String.split(".")
    |> Enum.at(-1)
    |> String.split("View")
    |> Enum.at(0)
    |> Macro.underscore()
    |> String.replace("/", "_")
    |> String.to_atom()
  end

  defp helpers_module(app) do
    [
      "Elixir.#{app}.Web.Router.Helpers",
      "Elixir.#{app}.Router.Helpers"
    ]
    |> Enum.map(&String.to_atom/1)
    |> Enum.find(fn module ->
      function_exported?(module, :__info__, 1)
    end)
  end
end
