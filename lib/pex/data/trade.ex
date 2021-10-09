defmodule Pex.Data.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    field(:symbol, :string)
    field(:quantity, :float)
    field(:price, :float)
    field(:take_profit, :float)
    field(:stop_loss, :float)
    field(:side, :string)
    field(:platform, :string)
    field(:take_profit_order_id, :string)
    field(:stop_loss_order_id, :string)

    # belongs_to(:purchase, Pex.Trade.Purchase)
    timestamps()
  end

  @attrs_required [
    :symbol,
    :quantity,
    :side,
    :platform
  ]

  @attrs @attrs_required ++
           [
             :price,
             :take_profit_order_id,
             :stop_loss_order_id,
             :take_profit,
             :stop_loss
           ]

  def changeset(order, params \\ %{}) do
    order
    |> cast(params, @attrs)
    |> validate_required(@attrs_required)
  end
end
