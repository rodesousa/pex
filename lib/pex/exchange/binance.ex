defmodule Pex.Exchange.Binance do
  alias Pex.Exchange
  @behaviour Exchange

  @impl Exchange
  def creds() do
    if System.get_env("BINANCE_API_KEY") == "" or System.get_env("BINANCE_SECRET_KEY") == "" do
      {:error, "You have to set BINANCE_API_KEY and BINANCE_SECRET_KEY"}
    else
      Binance.Config.set(:api_key, System.get_env("BINANCE_API_KEY"))
      Binance.Config.set(:secret_key, System.get_env("BINANCE_SECRET_KEY"))
    end
  end

  @impl Exchange
  def coin_list() do
    {:ok, %{balances: balances}} = Binance.get_account()

    balances
    |> Enum.filter(&(convert(&1["free"]) > 1.0 or convert(&1["locked"]) > 1.0))
    |> Enum.map(
      &%Exchange{
        symbol: &1["asset"],
        free: print(&1["free"]),
        locked: print(&1["locked"])
      }
    )
  end

  defp convert(string) do
    {value, _} = Float.parse(string)
    value
  end

  defp print(string) do
    float = convert(string)
    # I prefer to see 0.0 when there is less of 1.0
    if float < 1.0, do: 0.0, else: float
  end
end
