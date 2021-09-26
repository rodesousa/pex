defmodule Pex.Trade.Purchase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchases" do
    field(:symbol, :string)
    field(:quantity, :float)
    field(:price, :float)

    has_many(:orders, Pex.Trade.Order)
  end

  @attrs [:symbol, :quantity, :price]

  def changeset(purchase, params \\ %{}) do
    purchase
    |> cast(params, @attrs)
    |> validate_required(@attrs)
  end
end
