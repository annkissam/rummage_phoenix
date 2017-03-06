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

  @doc """
  `:default_per_page` can also be set at run time
  in the `config.exs` file

  ## Examples
  Returns default `Repo` set in the config
  (`2 in `rummage_ecto`'s test env):
      iex> alias Rummage.Phoenix
      iex> Phoenix.default_per_page
      2
  """
  def default_per_page do
    config(:default_per_page, "10")
  end

  @doc """
  `:default_helpers` can also be set at run time
  in the `config.exs` file

  ## Examples
  Returns default `Repo` set in the config
  (`2 in `rummage_ecto`'s test env):
      iex> alias Rummage.Phoenix
      iex> Phoenix.default_helpers
      Rummage.Phoenix.Router.Helpers
  """
  def default_helpers do
    config(:default_helpers, nil)
  end

  @doc false
  defp config do
    Application.get_env(:rummage_phoenix, Rummage.Phoenix, [])
  end

  @doc """
  `config` returns the value associated with the given `key` and returns `default` if
  the value is `nil`.

  ## Examples
  Returns value corresponding to config or returns the default value:
      iex> alias Rummage.Phoenix
      iex> Phoenix.config(:x, "default")
      "default"
  """
  def config(key, default \\ nil) do
    config()
    |> Keyword.get(key, default)
    |> resolve_config(default)
  end

  @doc """
  `resolve_system_config` returns a system variable set up or returns the
  specified default value

  ## Examples
  Returns value corresponding to a system variable config or returns the default value:
      iex> alias Rummage.Phoenix
      iex> Phoenix.resolve_system_config({:system, "some random config"}, "default")
      "default"
  """
  @spec resolve_system_config(Tuple.t, term) :: {term}
  def resolve_system_config({:system, var_name}, default) do
    System.get_env(var_name) || default
  end

  defp resolve_config(value, _default), do: value
end
