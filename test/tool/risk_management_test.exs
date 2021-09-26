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
end
