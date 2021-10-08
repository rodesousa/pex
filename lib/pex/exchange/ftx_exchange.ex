defmodule Pex.FtxExchange do
  alias Pex.Exchange
  @behaviour Exchange

  @impl Exchange
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

  @impl Exchange
  @doc """
  See behavior doc
  """
  def coins_list() do
    []
  end
end
