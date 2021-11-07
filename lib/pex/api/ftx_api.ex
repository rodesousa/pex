defmodule Pex.FtxAPI do
  @doc """
  See behavior doc
  """
  def creds() do
    if System.get_env("FTX_API_KEY") == "" or System.get_env("FTX_API_SECRET") == "" do
      {:error, "You have to set BINANCE_API_KEY and BINANCE_SECRET_KEY"}
    else
      %ExFtx.Credentials{
        api_key: System.get_env("FTX_API_KEY"),
        api_secret: System.get_env("FTX_API_SECRET")
      }
    end
  end

  @doc """
  /conditional_orders
  """
  def get_conditional_orders(), do: ExFtx.Orders.GetConditionalOrders.get(creds())

  def get_conditional_orders!() do
    {:ok, data} = get_conditional_orders()
    data
  end

  @doc """
  /markets
  """
  def coins_list(), do: ExFtx.Markets.List.get(creds())

  @doc """
  /account
  """
  def get_account(), do: ExFtx.Account.Show.get(creds())

  @doc """
  /orders
  """
  def order_limit_sell(symbol, quantity, tp),
    do:
      ExFtx.Orders.Create.post(creds(), %{
        price: tp,
        size: quantity,
        market: symbol
      })

  def get_balance, do: ExFtx.Wallet.Balances.get(creds())

  def get_balance! do
    {:ok, result} = get_balance()
    result
  end

  def get_price(pair), do: ExFtx.Markets.Show.get(pair)
end
