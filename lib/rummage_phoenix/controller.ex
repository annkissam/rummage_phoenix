defmodule RummagePhoenix.Controller do
  @moduledoc """
  Controller Module for RummagePhoenix. This builds rummage params and performs search action
  """

  defmacro __using__(opts) do
    used_hooks = (opts[:only] || [:search, :sort, :paginate])
      |> Enum.map(&Atom.to_string &1)

    quote do
      defp build_rummage_params(params) do
        unquote(Enum.each(used_hooks, fn(hook) ->
          quote do
            apply(__MODULE__, unquote(String.to_atom("rummage_#{hook}_params")), [params])
          end
        end))
      end
    end

    if "search" in used_hooks do
      quote do
        use RummagePhoenix.SearchController, struct: unquote(opts[:struct]), helper: unquote(opts[:helper])
      end
    end

    # Enum.each(used_hooks, fn(hook) ->
    #   controller = Module.concat("RummagePhoenix", "#{Macro.camelize(hook)}Controller")

    #   quote do
    #     use unquote(controller), struct: unquote(opts[:struct]), helper: unquote(opts[:helper])
    #   end
    # end)
  end
end
