defmodule Pex.Trade.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:type, :string)
    field(:quantity, :float)
    field(:price, :float)

    belongs_to(:purchase, Pex.Trade.Purchase)
  end

  @attrs [:symbol, :quantity, :price, :purchase_id]

  def changeset(order, params \\ %{}) do
    order
    |> cast(params, @attrs)
    |> validate_required(@attrs)
  end
end
