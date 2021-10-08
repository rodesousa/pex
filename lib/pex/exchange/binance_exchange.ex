defmodule Pex.BinanceExchange do
  alias Pex.Exchange
  @behaviour Exchange

  @impl Exchange
  @doc """
  See behavior doc
  """
  def creds() do
    if System.get_env("BINANCE_API_KEY") == "" or System.get_env("BINANCE_SECRET_KEY") == "" do
      {:error, "You have to set BINANCE_API_KEY and BINANCE_SECRET_KEY"}
    else
      Binance.Config.set(:api_key, System.get_env("BINANCE_API_KEY"))
      Binance.Config.set(:secret_key, System.get_env("BINANCE_SECRET_KEY"))
    end
  end
end
