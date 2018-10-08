defmodule Rummage.Phoenix.ThemeAdapter do
  @moduledoc """
  ThemeAdapter behaviour
  """

  @type txt :: String.t() | Phoenix.HTML.safe()
  @type hook :: :search | :sort | :paginate


  @callback pagination_links(Keyword.t(), do: txt()) :: txt()
  @callback page_link(txt(), String.t(), Keyword.t()) :: txt()
  @callback link_class_fn(hook(), Map.t()) :: any()
  @callback ellipsis() :: txt()
  @callback sort_link(txt(), String.t(), Keyword.t()) :: txt()
  @callback default_text_fn(hook()) :: any()

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)

      def pagination_links(opts, do: expr) do
        raise "pagination_links/2 not implemented for theme: #{__MODULE__}"
      end

      def page_link(text, href, opts) do
        raise "page_link/3 not implemented for theme: #{__MODULE__}"
      end

      def link_class_fn(hook, rummage) do
        raise "link_class_fn/2 not implemented for theme: #{__MODULE__}"
      end

      def ellipsis do
        raise "ellipsis/0 not implemented for theme: #{__MODULE__}"
      end

      def sort_link(text, href, opts) do
        raise "sort_link/3 not implemented for theme: #{__MODULE__}"
      end

      def default_text_fn(hook) do
        raise "default_text_fn/1 not implemented for theme: #{__MODULE__}"
      end

      defoverridable [pagination_links: 2, page_link: 3, link_class_fn: 2,
                      ellipsis: 0, sort_link: 3, default_text_fn: 1]
    end
  end
end
