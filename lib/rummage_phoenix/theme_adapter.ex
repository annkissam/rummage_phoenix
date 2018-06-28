defmodule Rummage.Phoenix.ThemeAdapter do
  @moduledoc """
  This module defines a behavior that `Rummage.Phoenix.ThemeAdapters` have to follow.
  Custom ThemeAdapters should follow this behavior and implement all the functions
  """
  @callback pagination_links(Keyword.t) :: term
  @callback page_link(String.t, Keyword.t) :: term
  @callback sort_link(String.t, Keyword.t) :: term
  @callback search_form(String.t, Keyword.t) :: term

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)

      def pagination_links(_), do: raise "pagination_links/1 is Not Implemented for #{__MODULE__}"
      def page_link(_, _), do: raise "page_link/2 is Not Implemented for #{__MODULE__}"
      def sort_link(_, _), do: raise "sort_link/2 is Not Implemented for #{__MODULE__}"
      def search_form(_, _), do: raise "search_link/2 is Not Implemented for #{__MODULE__}"

      defoverridable [pagination_links: 1, page_link: 2,
                      sort_link: 2, search_form: 2]
    end
  end
end
