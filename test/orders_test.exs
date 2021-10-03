defmodule Pex.OrdersTest do
  use Pex.RepoCase
  alias Pex.Trade.Order
  alias Pex.Orders

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
    {:ok, order} = Orders.create_order(@valid_attrs)

    order
  end

  test "create_order/1 with valid data" do
    assert {:ok, %Order{} = order} = Orders.create_order(@valid_attrs)
  end

  test "create_order/1 with invalid data" do
    assert {:error, %Ecto.Changeset{}} = Orders.create_order(@error_attrs)
  end

  test "list_orders/0" do
    assert [] = Orders.list_orders()
    order_fixture()
    assert [order] = Orders.list_orders()
  end

  test "delete_orders/O" do
    order_fixture()
    assert {1, nil} = Orders.delete_orders()
  end

  test "delete_order/1" do
    order = order_fixture()
    assert {:ok, order = %Order{}} = Orders.delete_order(order.id)
  end

  test "update_order/2" do
    init = order_fixture()
    assert {:ok, %Order{} = order} = Orders.update_order(init.id, @update_attrs)
    assert order.quantity == @update_attrs.quantity
  end
end
