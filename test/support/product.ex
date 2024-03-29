defmodule Rummage.Ecto.Product do
  @moduledoc false
  use Ecto.Schema

  schema "products" do
    field(:name, :string)
    field(:price, :float)
    belongs_to(:category, Rummage.Ecto.Category)

    timestamps()
  end
end
