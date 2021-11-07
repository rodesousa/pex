defmodule Pex.FtxTrade do
  alias Pex.RiskManagement, as: RM
  alias Pex.Exchange
  require Logger

  @api Application.get_env(:pex, :ftx_api)
  @exchange_info "ftx_exchange_info.json"

  @doc """
  Gets a binance exchange info for price filter and lot size
  """
  def load_exchange_info(), do: Pex.Exchange.load_exchange_from_file!(@exchange_info)

  @doc """
  Saves binance exchange info for price filter and lot size
  """
  def save_exchange_info() do
    {:ok, data} = ExFtx.Markets.List.get()

    Pex.Exchange.save_exchange_to_file!(@exchange_info, data)
  end

  @doc """
  Returns account balance total in USDT

  # Examples

      iex> get_balance
      1239.23
  """
  def get_balance() do
    @api.get_balance!()
    |> Enum.reduce(0, fn pair, acc ->
      pair.usd_value + acc
    end)
    |> Float.ceil(2)
  end

  @doc """
  List of coins in our portfolio

  # Examples

      iex> coins_list()
      [%{symbol: "SOL", free: 0.0, locked: 1.0}, ...}
  """
  def coins_list() do
    balances = @api.get_balance!()

    conditional_orders =
      @api.get_conditional_orders!()
      |> Enum.group_by(&(&1.size && &1.market))

    balances
    |> Enum.filter(&(&1.free > 0.0001 or &1.spot_borrow > 0.0001))
    |> Enum.map(fn symbol ->
      conditional_size =
        Enum.reduce(conditional_orders, 0, fn {key, value}, acc ->
          [from, _to] = String.split(key, "/")

          if from == symbol.coin and length(value) == 2,
            do: List.first(value).size + acc,
            else: acc
        end)

      %{
        symbol: symbol.coin,
        free: symbol.free - conditional_size,
        locked: symbol.spot_borrow + conditional_size
      }
    end)
  end

  @doc """
  Returns a %RiskManagement{} if exchange constraints (price filter, quantity filter) are respected

  # Examples

  iex> init_risk_management("SOL/USDT", 10.0)
  {:ok, %RiskManagement{...}}
  """
  @spec init_risk_management(String.t(), float | nil) ::
          {:ok, %RM{}} | {:error, String.t()}
  def init_risk_management(_pair, nil) do
    {:error, "shad not implemented"}
  end

  def init_risk_management(pair, distance) when is_float(distance) do
    {:ok, %{price: price}} = @api.get_price(pair)

    [
      %{
        "min_provide_size" => quantity_size,
        "price_increment" => price_size
      }
    ] =
      load_exchange_info()
      |> Enum.filter(&(&1["name"] == pair))

    risk =
      Pex.RiskManagement.computes_risk(%{
        balance: get_balance(),
        distance: distance,
        coin_price: price,
        future: 1
      })

    {:ok,
     %{
       risk
       | quantity: Exchange.trunc(risk.quantity, quantity_size),
         stop_loss: Exchange.trunc(risk.stop_loss, price_size),
         limit: Exchange.trunc(risk.limit, price_size),
         pair: pair,
         pair_price: price
     }}
  end

  defp market_sell(
         %{
           price: bought,
           stop: stop_loss,
           limit: limit,
           quantity: quantity,
           pair: pair
         },
         take_profit
       ) do
    compare = fn
      _atom, true -> true
      atom, false -> atom
    end

    with true <- compare.(:price, bought > stop_loss),
         true <- compare.(:stop, stop_loss > limit),
         true <- compare.(:tp, take_profit > bought) do
    else
      :price ->
        Logger.error("Sell is impossible because price < stop")
        {:error, "price < stop"}

      :stop ->
        Logger.error("Sell is impossible because stop < limit")
        {:error, "stop < limit"}

      :tp ->
        Logger.error("Sell is impossible because tp < price")
        {:error, "tp < price"}

      _ ->
        nil
    end
  end
end
