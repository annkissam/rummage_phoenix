defmodule Rummage.Ecto.Category do
  @moduledoc false
  use Ecto.Schema

  schema "categories" do
    field(:category_name, :string)

    timestamps()
  end
end
