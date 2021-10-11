defmodule PexTest.Tool.RiskManagement do
  use ExUnit.Case
  alias Pex.RiskManagement, as: RM

  @rm %{balance: 50_000, risk: 3, distance: 5.0, future: 1, coin_price: 2.0}

  test "computes_risk/1" do
    risk = RM.computes_risk(@rm)
    balance_with_stop_loss = @rm.balance - @rm.balance * (@rm.risk / 100)
    assert risk.position_size == 30000
    assert risk.quantity == 15000
    assert risk.cost == 30000
    assert risk.stop_loss == 1.9
    assert balance_with_stop_loss == 4.85e4

    assert risk.cost - risk.stop_loss * risk.quantity ==
             @rm.balance - balance_with_stop_loss

    risk
    |> IO.inspect()
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
