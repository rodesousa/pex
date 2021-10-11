defmodule Pex.StatTest do
  use ExUnit.Case
  doctest Pex.Data.Trade
  alias Pex.Stat

  test "percent_order/2" do
    order = %{
      stop_loss: 1.0,
      take_profit: 3.0,
      price: 2.0
    }

    assert Stat.percent_order(order, 2.5) == 50.0
    assert Stat.percent_order(order, 2.25) == 25.0
    assert Stat.percent_order(order, 3.0) == 100.0

    assert Stat.percent_order(order, 1.5) == -50.0
    assert Stat.percent_order(order, 1.75) == -25.0
    assert Stat.percent_order(order, 1.0) == -100.0

    order = %{
      stop_loss: nil,
      take_profit: 3.0,
      price: 2.0
    }

    assert Stat.percent_order(order, 3.0) == 100.0
    assert Stat.percent_order(order, 1.0) == -100.0
  end
end
