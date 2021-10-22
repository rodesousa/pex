defmodule Pex.KucoinAPI do
  defp config do
    %ExKucoin.Config{
      api_key: System.get_env("KUCOIN_API_KEY"),
      api_secret: System.get_env("KUCOIN_API_SECRET"),
      api_passphrase: System.get_env("KUCOIN_API_PASSPHRASE")
    }
  end

  @doc """
  /api/v1/accounts
  """
  def get_account, do: ExKucoin.User.Account.all(%{}, config())

  @doc """
  /api/v1/prices
  """
  def get_price(params) when is_map(params), do: ExKucoin.Market.Price.all(params, config())

  def get_price(coin) when is_binary(coin),
    do: ExKucoin.Market.Price.all(%{curencies: coin}, config())

  @doc """
  /api/v1/stop-order
  """
  def get_stop_order(), do: ExKucoin.StopOrder.Order.list(%{}, config())
end
