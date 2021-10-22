defmodule PexTest.Tool.RiskManagement do
  use ExUnit.Case
  alias Pex.RiskManagement, as: RM

  test "computes_risk/1 with price < 200.0" do
    rm = %{balance: 50_000, risk: 3, distance: 5.0, future: 1, coin_price: 2.0}
    risk = RM.computes_risk(rm)
    balance_with_stop_loss = rm.balance - rm.balance * (rm.risk / 100)
    assert risk.position_size == 30000
    assert risk.quantity == 15000
    assert risk.cost == 30000
    assert risk.stop_loss == 1.9
    assert balance_with_stop_loss == 4.85e4

    assert risk.cost - risk.stop_loss * risk.quantity ==
             rm.balance - balance_with_stop_loss
  end

  test "computes_risk/1 with price > 200.0" do
    rm = %{balance: 50_000, risk: 3, distance: 5.0, future: 1, coin_price: 250.04}
    risk = RM.computes_risk(rm)
    balance_with_stop_loss = rm.balance - rm.balance * (rm.risk / 100)
    assert risk.position_size == 30000
    assert risk.quantity == 119.99
    assert risk.cost == 30002.3
    assert risk.stop_loss == 237.5
    assert balance_with_stop_loss == 4.85e4
  end

  test "computes_limit_from_stop/1 for > 1" do
    assert RM.computes_limit_from_stop(1.0) == 0.99
    assert RM.computes_limit_from_stop(10.0) == 9.94
    assert RM.computes_limit_from_stop(100.0) == 99.5
    assert RM.computes_limit_from_stop(52000.0) == 51740.0
  end

  test "computes_limit_from_stop/1 for < 1" do
    assert RM.computes_limit_from_stop(0.1) == 0.0995
    assert RM.computes_limit_from_stop(0.01) == 0.0099
    assert RM.computes_limit_from_stop(0.001) == 0.0009
    assert RM.computes_limit_from_stop(0.0001) == 0.00009
    assert RM.computes_limit_from_stop(0.001145) == 0.001139
  end
end
