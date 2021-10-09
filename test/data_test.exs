defmodule Pex.DataTest do
  use Pex.RepoCase
  alias Pex.Data
  alias Pex.Data.Trade

  @valid_attrs %{
    symbol: "BTCUSDT",
    quantity: "1",
    side: "BUY",
    platform: "binance"
  }

  @update_attrs %{
    quantity: 2
  }

  @error_attrs %{
    symbol: nil,
    quantity: nil,
    side: nil,
    platform: nil
  }

  def order_fixture() do
    {:ok, order} = Data.create_trade(@valid_attrs)

    order
  end

  test "create_trade/1 with valid data" do
    assert {:ok, %Trade{} = order} = Data.create_trade(@valid_attrs)
  end

  test "create_trade/1 with invalid data" do
    assert {:error, %Ecto.Changeset{}} = Data.create_trade(@error_attrs)
  end

  test "list_trades/0" do
    assert [] = Data.list_trades()
    order_fixture()
    assert [_trade] = Data.list_trades()
  end

  test "delete_orders/O" do
    order_fixture()
    assert {1, nil} = Data.delete_orders()
  end

  test "delete_order/1" do
    order = order_fixture()
    assert {:ok, order = %Trade{}} = Data.delete_order(order.id)
  end

  test "update_order/2" do
    init = order_fixture()
    assert {:ok, %Trade{} = trade} = Data.update_trade(init.id, @update_attrs)
    assert trade.quantity == @update_attrs.quantity
  end
end
