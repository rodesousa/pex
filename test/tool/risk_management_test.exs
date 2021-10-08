defmodule PexTest.Tool.RiskManagement do
  use ExUnit.Case
  alias Pex.Tool.RiskManagement, as: RM

  @rm %RM{portfolio: 50_000, risk: 3, distance: 5.0}

  test "computes sucessfully position size" do
    assert RM.position_size(@rm) == 30000
  end

  test "checks price is <= than risk" do
    risk = RM.computes_risk(@rm, 6, 1)
    assert 50000 * 0.03 == risk.price * 0.05
  end

  test "computes_decrease/2" do
    assert RM.computes_decrease(100.0, 20.0) == 80.0
    assert RM.computes_decrease(212.5050, 14.08) == 182.584296
  end

  test "computes_limit_from_stop/1 for > 1" do
    assert RM.computes_limit_from_stop(1.0) == {:ok, 0.995}
    assert RM.computes_limit_from_stop(10.0) == {:ok, 9.95}
    assert RM.computes_limit_from_stop(100.0) == {:ok, 99.5}
    assert RM.computes_limit_from_stop(1000.0) == {:ok, 999}
  end

  test "computes_limit_from_stop/1 for < 1" do
    assert RM.computes_limit_from_stop(0.1) == {:ok, 0.0995}
    assert RM.computes_limit_from_stop(0.01) == {:ok, 0.00995}
    assert RM.computes_limit_from_stop(0.001) == {:ok, 0.000995}
    assert RM.computes_limit_from_stop(0.0001) == {:ok, 0.0000995}
  end
end
