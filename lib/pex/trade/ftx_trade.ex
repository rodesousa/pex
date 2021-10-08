defmodule Pex.FtxTrade do
  alias Pex.FtxExchange

  @doc """
  Places a market order
  """
  def buy_market(symbol, quantity) do
    payload = %ExFtx.OrderPayload{
      market: symbol,
      type: "market",
      size: quantity,
      side: "buy"
    }

    ExFtx.Orders.Create.post(FtxExchange.creds(), payload)
  end
end
