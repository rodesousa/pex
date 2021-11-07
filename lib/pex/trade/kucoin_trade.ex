defmodule Pex.KucoinTrade do
  @behaviour Pex.Exchange

  alias Pex.Exchange
  alias Pex.RiskManagement, as: RM
  require Logger

  @api Application.get_env(:pex, :kucoin_api)
  @exchange_info "kucoin_exchange_info.json"

  @doc """
  Gets a binance exchange info for price filter and lot size
  """
  def load_exchange_info(), do: Pex.Exchange.load_exchange_from_file!(@exchange_info)

  @doc """
  Saves kucoin exchange info for price filter and lot size
  """
  def save_exchange_info() do
    {:ok, %{"data" => data}} = ExKucoin.Market.Symbol.all()
    Pex.Exchange.save_exchange_to_file!(@exchange_info, data)
  end

  @doc """
  Returns account balance total in USDT

  # Examples

      iex> get_balance
      1239.23
  """
  @impl Pex.Exchange
  def get_balance() do
    {:ok, %{"data" => data}} = @api.get_account

    price = fn
      0.0, _symbol ->
        0.0

      value, coin ->
        value * coin_price(%{currencies: coin})
    end

    data
    |> Enum.reduce(0, fn
      %{
        "balance" => balance,
        "currency" => coin
      },
      acc ->
        {balance, _e} = Float.parse(balance)
        price.(balance, coin) + acc
    end)
    |> Float.ceil(2)
  end

  @doc """
  Gets coin price in USDT

  # Examples

      iex> coin_price("SOL")
      1.0
  """
  def coin_price(symbol) when is_binary(symbol), do: coin_price(%{currencies: symbol})
  def coin_price(%{currencies: "USDT"}), do: 1

  def coin_price(params) do
    {:ok, %{"data" => data}} = @api.get_price(params)
    [price] = Enum.map(data, fn {_symbol, price} -> price end)

    String.to_float(price)
  end

  @doc """
  List of coins in Kucoin portfolio

  # Examples

      iex> coins_list()
      [%{symbol: "SOL", free: 0.0, locked: 1.0}, ...}
  """
  def coins_list() do
    {:ok, %{"data" => data}} = @api.get_account
    {:ok, %{"data" => %{"items" => orders}}} = @api.get_stop_order()

    data
    |> Enum.reduce([], fn
      %{"available" => "0"}, acc ->
        acc

      %{
        "currency" => coin,
        "holds" => holds,
        "available" => available
      },
      acc ->
        {free, _e} = Float.parse(available)
        {locked, _e} = Float.parse(holds)

        case coin_has_stop_orders?(coin, available, orders) do
          false -> [%{symbol: coin, free: free, locked: locked} | acc]
          true -> [%{symbol: coin, free: 0, locked: locked + free} | acc]
        end
    end)
  end

  @doc false
  def coin_has_stop_orders?(coin, quantity, stop_orders) do
    Enum.filter(stop_orders, fn
      %{"size" => size, "symbol" => symbol} ->
        symbol = symbol |> String.split("-") |> List.first()
        {quantity, _e} = Float.parse(quantity)
        {size, _e} = Float.parse(size)

        coin == symbol and flexible_equality(quantity, size)
    end)
    |> Enum.empty?()
    |> Kernel.not()
  end

  defp flexible_equality(a, b) do
    if a > b do
      (a - b) / a < 0.01
    else
      (b - a) / b < 0.01
    end
  end

  @doc """
  Buy `pair`
  Places a stop loss limit and a take profit limit computed by `distance`

  # Examples

      iex> trade_buy("BNB-USDT", 10.0, 12.0)
      :ok
  """
  def trade_buy(pair, take_profit, distance \\ nil) do
    {:ok, risk} = init_risk_management(pair, take_profit, distance)

    # {:ok, %{"code" => "200000", "data" => %{"orderId" => order_id}}} =
    {:ok, %{"code" => "200000"}} =
      @api.new_order(%{
        "side" => "buy",
        "symbol" => pair,
        "type" => "market",
        "size" => risk.quantity,
        "clientOid" => UUID.uuid1()
      })

    market_sell(risk)
  end

  @doc """
  Returns a %RiskManagement{} if exchange constraints (price filter, quantity filter) are respected

  # Examples

      iex> init_risk_management("SOL-USDT", 18.0, 10.0)
      {:ok, %RiskManagement{...}}
  """
  @spec init_risk_management(String.t(), float, float | nil) ::
          {:ok, %RM{}} | {:error, String.t()}
  def init_risk_management(_pair, _take_profit, nil) do
    {:error, "shad not implemented"}
  end

  def init_risk_management(pair, take_profit, distance) do
    [coin, _a] = String.split(pair, "-")
    {:ok, %{"data" => data}} = @api.get_price(coin)
    price = String.to_float(data[coin])

    [
      %{
        "baseIncrement" => quantity_size,
        "priceIncrement" => price_size
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
         pair_price: price,
         take_profit: take_profit,
         limit_take_profit: RM.decrease(take_profit) |> Exchange.trunc(price_size)
     }}
  end

  def market_sell(%RM{
        pair_price: bought,
        stop_loss: stop_loss,
        limit: limit,
        quantity: quantity,
        pair: pair,
        take_profit: take_profit,
        limit_take_profit: limit_take_profit
      }) do
    compare = fn
      _atom, true -> true
      atom, false -> atom
    end

    with true <- compare.(:price, bought > stop_loss),
         true <- compare.(:stop, stop_loss > limit),
         true <- compare.(:tp, take_profit > bought),
         true <- compare.(:tp, take_profit > limit_take_profit) do
      {:ok, %{"code" => "200000"}} =
        @api.new_stop_order(%{
          "clientOid" => UUID.uuid1(),
          "side" => "sell",
          "symbol" => pair,
          "type" => "limit",
          "size" => quantity,
          "price" => limit,
          "stopPrice" => stop_loss
        })

      {:ok, %{"code" => "200000"}} =
        @api.new_stop_order(%{
          "clientOid" => UUID.uuid1(),
          "side" => "sell",
          "symbol" => pair,
          "type" => "limit",
          "size" => quantity,
          "stop" => "entry",
          "price" => limit_take_profit,
          "stopPrice" => take_profit
        })
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
