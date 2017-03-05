defmodule Rummage.Phoenix.Plug do
  @moduledoc """
  This plug ensures that a invalid JWT was provided and has been
  verified on the request.

  If one is found, the `already_authenticated/2` function is invoked with the
  `Plug.Conn.t` object and its params.

  ## Example

      # Will call the already_authenticated/2 function on your handler
      plug Guardian.Plug.EnsureNotAuthenticated, handler: SomeModule

      # look in the :secret location.  You can also do simple claim checks:
      plug Guardian.Plug.EnsureNotAuthenticated, handler: SomeModule,
                                                 key: :secret

      plug Guardian.Plug.EnsureNotAuthenticated, handler: SomeModule,
                                                 typ: "access"

  If the handler option is not passed, `Guardian.Plug.ErrorHandler` will provide
  the default behavior.
  """
  def init(params) do
    params
  end

  def call(conn, opts) do
    hooks = opts[:hooks]
    before_action(conn, hooks)
  end

  defp before_action(conn, hooks) do
    case conn.private[:phoenix_action] == :index do
      true -> %Plug.Conn{conn | params: rummage_params(conn.params, hooks)}
      _ -> conn
    end
  end

  defp rummage_params(params, hooks) do
    case Map.get(params, "rummage") do
      nil ->
        Map.put(params, "rummage",
          Enum.map(hooks, &{&1, %{}})
          |> Enum.into(%{})
        )
      rummage ->
        Map.put(params, "rummage",
          Enum.map(hooks, &{&1,
            apply(String.to_atom("Elixir.Rummage.Phoenix.#{String.capitalize(&1)}Controller"),
            :rummage, [rummage])})
          |> Enum.into(%{})
        )
    end
  end
end
