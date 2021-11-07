defmodule Pex.FtxTradeTest do
  use Pex.RepoCase
  alias Pex.FtxTrade, as: FT
  alias Pex.Data.Trade

  test "get_balance/0" do
    assert 1106.4 == FT.get_balance()
  end

  test "coins_list/0" do
    coin = FT.coins_list() |> List.first()
    assert %{symbol: _s, free: _f, locked: _l} = coin
  end
end
