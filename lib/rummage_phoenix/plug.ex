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
      iex> options = %{}
      iex> Plug.init(options)
      %{}
  """
  def init(options) do
    options
  end

  @doc """
  `conn` initializes the plug and returns the `params` passed
  to it:

  ## Examples
      iex> opts = %{hooks: ["search", "sort", "paginate"], actions: [:index]}
      iex> conn = %Plug.Conn{}
      iex> Rummage.Phoenix.Plug.call(conn, opts) == conn
      true

      iex> opts = %{hooks: ["search", "sort", "paginate"], actions: [:index]}
      iex> conn = %Plug.Conn{params: %{}, private: %{phoenix_action: :index}}
      iex> Rummage.Phoenix.Plug.call(conn, opts) == %Plug.Conn{params: %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}}, private: %{phoenix_action: :index}}
      true

      iex> opts = %{hooks: ["search", "sort", "paginate"], actions: [:index]}
      iex> conn = %Plug.Conn{params: %{"rummage" => %{}}, private: %{phoenix_action: :index}}
      iex> Rummage.Phoenix.Plug.call(conn, opts) == %Plug.Conn{params: %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}}, private: %{phoenix_action: :index}}
      true

      iex> opts = %{hooks: ["search", "sort", "paginate"], actions: [:index]}
      iex> conn = %Plug.Conn{params: %{"rummage" => %{}}, private: %{phoenix_action: :show}}
      iex> Rummage.Phoenix.Plug.call(conn, opts) == conn
      true

      iex> opts = %{hooks: ["search", "sort", "paginate"], actions: [:index, :show]}
      iex> conn = %Plug.Conn{params: %{"rummage" => %{}}, private: %{phoenix_action: :show}}
      iex> Rummage.Phoenix.Plug.call(conn, opts) == %Plug.Conn{params: %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}}, private: %{phoenix_action: :show}}
      true
  """
  def call(conn, opts) do
    hooks = Map.fetch!(opts, :hooks)
    actions = Map.fetch!(opts, :actions)
    before_action(conn, hooks, actions)
  end

  defp before_action(conn, hooks, actions) do
    case Enum.member?(actions, conn.private[:phoenix_action]) do
      true -> %Plug.Conn{conn | params: rummage_params(conn.params, hooks)}
      _ -> conn
    end
  end

  defp rummage_params(params, hooks) do
    case Map.get(params, "rummage") do
      nil ->
        Map.put(
          params,
          "rummage",
          Enum.map(hooks, &{&1, %{}})
          |> Enum.into(%{})
        )

      rummage ->
        Map.put(
          params,
          "rummage",
          Enum.map(
            hooks,
            &{&1,
             apply(
               String.to_atom("Elixir.Rummage.Phoenix.#{String.capitalize(&1)}Controller"),
               :rummage,
               [rummage]
             )}
          )
          |> Enum.into(%{})
        )
    end
  end
end
