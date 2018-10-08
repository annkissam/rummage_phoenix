defmodule Rummage.Phoenix.Config do
  @moduledoc """
  TODO: Add docs
  """

  @doc """
  `per_page` can also be set at run time
  in the `config.exs` file

  ## Examples
  Returns default `per_page` set in the config
  (`2 in `Rummage.Phoenix`'s test env):
      iex> alias Rummage.Phoenix
      iex> Phoenix.per_page()
      2
  """
  def per_page(application \\ :rummage_phoenix) do
    config(:per_page, 10, application)
  end

  @doc """
  `helpers` can also be set at run time
  in the `config.exs` file

  ## Examples
  Returns default `helpers` set in the config
  (`Rummage.Phoenix.Router.Helpers in `Rummage.Phoenix`'s test env):
      iex> alias Rummage.Phoenix
      iex> Phoenix.router_helpers()
      nil
  """
  def router_helpers(application \\ :rummage_phoenix) do
    config(:router_helpers, nil, application)
  end

  @doc """
  `theme` can also be set at run time
  in the `config.exs` file

  ## Examples
  Returns default `theme` set in the config
  (`:bootstrap in `Rummage.Phoenix`'s test env):
      iex> alias Rummage.Phoenix
      iex> Phoenix.css()
      Rummage.Phoenix.Bootstrap3
  """
  def css(application \\ :rummage_phoenix) do
    config(:css, Rummage.Phoenix.Bootstrap3, application)
  end

  @doc """
  `max_page_links` can also be set at run time
  in the `config.exs` file

  ## Examples
  Returns default `default_max_page_links` set in the config
  (`5 in `Rummage.Phoenix`'s test env):
      iex> alias Rummage.Phoenix
      iex> Phoenix.max_pagination_links()
      5
  """
  def max_pagination_links(application \\ :rummage_phoenix) do
    config(:max_pagination_links, 5, application)
  end

  defp config(application) do
    Application.get_env(application, Rummage.Ecto, [])
  end

  @doc """
  `config` returns the value associated with the given `key` and returns `default` if
  the value is `nil`.

  ## Examples
  Returns value corresponding to config or returns the default value:
      iex> alias Rummage.Phoenix
      iex> Phoenix.config(:x, "default", :rummage_phoenix)
      "default"
  """
  def config(key, default, application) do
    application
    |> config()
    |> Keyword.get(key, default)
    |> resolve_config(default)
  end

  defp resolve_config(value, _default), do: value
end
