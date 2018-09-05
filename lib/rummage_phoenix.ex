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
  [this link](https://github.com/annkissam/rummage_phoenix_example).
  """
end
