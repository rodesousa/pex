defmodule Pex.Trade.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:symbol, :string)
    field(:type, :string)
    field(:quantity, :float)
    field(:price, :float)
    field(:state, :string)
    field(:exchange_order_id, :string)
    field(:side, :string)
    field(:platform, :string)

    belongs_to(:purchase, Pex.Trade.Purchase)
    timestamps()
  end

  @attrs_required [:quantity, :price, :state, :symbol, :side, :platform]

  @attrs @attrs_required ++ [:exchange_order_id, :type]

  def changeset(order, params \\ %{}) do
    order
    |> cast(params, @attrs)
    |> validate_required(@attrs_required)
  end
end
