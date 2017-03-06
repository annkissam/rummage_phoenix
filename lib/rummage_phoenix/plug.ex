defmodule Rummage.Phoenix.Plug do
  @moduledoc """
  This plug ensures that the `rummage` params are properly set before
  `index` action of the controller. If they are not, then it formats them
  accordingly.

  This plug only works with the default `Rummmage.Ecto` hooks.
  """

  @doc """
  `init` initializes the plug and returns the `params` passed
  to it:

  ## Examples
      iex> alias Rummage.Phoenix.Plug
      iex> params = %{}
      iex> Plug.init(params)
      %{}
  """
  def init(params) do
    params
  end

  @doc """
  `conn` initializes the plug and returns the `params` passed
  to it:

  ## Examples
      iex> params = %{}
      iex> conn = %Plug.Conn{}
      iex> Rummage.Phoenix.Plug.call(conn, params) == conn
      true

      iex> params = %{hooks: ["search", "sort", "paginate"]}
      iex> conn = %{__struct__: Plug.Conn, params: %{}, private: %{phoenix_action: :index}}
      iex> Rummage.Phoenix.Plug.call(conn, params) == %{__struct__: Plug.Conn, params: %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}}, private: %{phoenix_action: :index}}
      true

      iex> params = %{hooks: ["search", "sort", "paginate"]}
      iex> conn = %{__struct__: Plug.Conn, params: %{"rummage" => %{}}, private: %{phoenix_action: :index}}
      iex> Rummage.Phoenix.Plug.call(conn, params) == %{__struct__: Plug.Conn, params: %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}}, private: %{phoenix_action: :index}}
      true
  """
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
