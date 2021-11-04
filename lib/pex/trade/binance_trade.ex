defmodule Pex.BinanceTrade do
  alias Pex.Data
  alias Pex.RiskManagement, as: RM

  @api Application.get_env(:pex, :binance_api)
  @exchange_info "binance_exchange_info.json"

  @doc """
  Gets a binance exchange info for price filter and lot size
  """
  def load_exchange_info(), do: Pex.Exchange.load_exchange_from_file!(@exchange_info)

  @doc """
  Saves binance exchange info for price filter and lot size
  """
  def save_exchange_info() do
    {:ok, %{symbols: data}} = Binance.get_exchange_info()
    Pex.Exchange.save_exchange_to_file!(@exchange_info, data)
  end

  @doc """
  Returns account balance total in USDT

  # Examples

      iex> get_balance
      1239.23
  """
  def get_balance() do
    {:ok, %{balances: balances}} = @api.get_account()

    price = fn
      0.0, _symbol -> 0.0
      value, symbol -> coin_price(@api, symbol) * value
    end

    balances
    |> Enum.reduce(0, fn
      %{"asset" => asset, "free" => free, "locked" => locked}, acc ->
        price.(String.to_float(free) + String.to_float(locked), asset) + acc
    end)
    |> Float.ceil(2)
  end

  @doc """
  # Examples

      iex> coin_price(api, "SOL")
      1.0
  """
  def coin_price(_api, "USDT"), do: 1

  def coin_price(api, symbol) do
    with {:ok, %{price: price}} <- api.get_price(symbol <> "USDT") do
      String.to_float(price)
    else
      _ ->
        {:ok, %{price: btc_price}} = api.get_price(symbol <> "BTC")
        {:ok, %{price: usdt_price}} = api.get_price("BTCUSDT")
        String.to_float(usdt_price) * String.to_float(btc_price)
    end
  end

  @doc """
  List of coins in our portfolio

  # Examples

      iex> coins_list()
      [%{symbol: "SOL", free: 0.0, locked: 1.0}, ...}
  """
  def coins_list() do
    {:ok, %{balances: balances}} = @api.get_account()

    balances
    |> Enum.filter(
      &(String.to_float(&1["free"]) > 0.0001 or String.to_float(&1["locked"]) > 0.0001)
    )
    |> Enum.map(
      &%{
        symbol: &1["asset"],
        free: String.to_float(&1["free"]) |> Float.ceil(4),
        locked: String.to_float(&1["locked"]) |> Float.ceil(4)
      }
    )
  end

  @doc """
  Gets coins list without local order
  """
  def coins_list_without_trade do
    trades = Data.list_trades() |> Enum.filter(&(&1.platform == "binance"))
    {:ok, binance_orders} = @api.get_open_orders()

    binance_orders
    |> Enum.reduce([], fn
      %{symbol: "USDT"}, acc -> acc
      coin, acc -> create_list_without_order(acc, trades, coin)
    end)
    |> Enum.group_by(&(&1.quantity && &1.symbol))
  end

  defp create_list_without_order(acc, local_orders, coin) do
    case find_orders(local_orders, coin.order_id) do
      nil ->
        [
          %{
            symbol: coin.symbol,
            order_id: coin.order_id,
            quantity: coin.orig_qty,
            price: coin.price
          }
          | acc
        ]

      _ ->
        acc
    end
  end

  defp find_orders(orders, order_id) do
    Enum.find(orders, fn order ->
      order.take_profit_order_id == Integer.to_string(order_id) or
        order.stop_loss_order_id == Integer.to_string(order_id)
    end)
  end

  # @doc """
  # Creates a trade with shad strategy

  ## Examples

  # iex> create_shad(
  # %{
  # symbol: "AIONUSDT",
  # take_profit_order_id: "122658019",
  # price: 1.0
  # })
  # {:ok, %Trade{}}
  # """
  # def create_shad(%{
  # take_profit_order_id: take_profit_order_id,
  # price: price,
  # symbol: symbol
  # }) do
  # {:ok, orders} = @api.get_open_orders(symbol)

  # case Enum.find(orders, &(&1.order_id == String.to_integer(take_profit_order_id))) do
  # nil ->
  # {:error, "take_profit_order_id not found"}

  # take_profit ->
  # Data.create_trade(%{
  # symbol: symbol,
  # quantity: take_profit.orig_qty,
  # take_profit: take_profit.price,
  # take_profit_order_id: take_profit_order_id,
  # side: take_profit.side,
  # price: price,
  # platform: "binance"
  # })
  # end
  # end

  @doc """
  TODO
  """
  def trade_buy(pair, tp, distance \\ nil) do
    with {:ok, risk} <-
           init_risk_management(pair, distance),
         {:buy, _risk, {:ok, _coin}} <-
           {:buy, risk, @api.order_market_buy(pair, risk.quantity)},
         {:ok, %{"orderReports" => order_reports}} <-
           oco_order(risk, tp),
         {:ok, trade} <-
           save_trade_from_oco(risk.pair, risk.pair_price, order_reports) do
      {:ok, trade}
    else
      {:buy, risk, error} ->
        IO.inspect("During the order maket buy: risk #{inspect(risk)}")
        error

      error ->
        error
    end
  end

  @doc """
  Returns a %RiskManagement{} if exchange constraints (price filter, quantity filter) are respected

  # Examples

      iex> init_risk_management("SOLUSDT", 10.0)
      {:ok, %RiskManagement{...}}
  """
  @spec init_risk_management(String.t(), float | nil) ::
          {:ok, %RM{}} | {:error, String.t()}
  def init_risk_management(_pair, nil) do
    {:error, "shad not implemented"}
  end

  def init_risk_management(pair, distance) when is_float(distance) do
    {:ok, %{price: price}} = @api.get_price(pair)
    price = String.to_float(price)
    balance = get_balance()

    params = %{
      balance: balance,
      distance: distance,
      coin_price: price,
      future: 1
    }

    {:ok, exchange_info} = exchange_info_filter(pair)

    case risk_constraints(Pex.RiskManagement.computes_risk(params), exchange_info) do
      {:ok, risk} ->
        {:ok,
         %{
           risk
           | quantity: trim_quantity(risk.quantity, exchange_info),
             stop_loss: trim_price(risk.stop_loss, exchange_info),
             limit: trim_price(risk.limit, exchange_info),
             pair: pair,
             pair_price: price
         }}

      error ->
        error
    end
  end

  defp risk_constraints(
         %RM{
           quantity: quantity,
           stop_loss: stop_loss,
           limit: limit
         } = risk,
         exchange_info
       ) do
    with {_, true} <- {:quantity, right_quantity?(quantity, exchange_info)},
         {_, true} <- {:limit, right_price?(limit, exchange_info)},
         {_, true} <- {:stop_loss, right_price?(stop_loss, exchange_info)} do
      {:ok, risk}
    else
      {atom, false} -> {:error, "#{atom} doest not respect the exchange info"}
    end
  end

  @doc """
  Gets the pair price & quantity filter from exchange info

  # Examples

      iex> exchange_info_filter("SPARTA", "BNB")
      {:ok,
        %{
          price: %{
            "filterType" => "PRICE_FILTER",
            "maxPrice" => "1000.00000000",
            "minPrice" => "0.00000010",
            "tickSize" => "0.00000010"
          },
          quantity: %{
            "filterType" => "LOT_SIZE",
            "maxQty" => "9000000.00000000",
            "minQty" => "1.00000000",
            "stepSize" => "1.00000000"
          }
        }
      }
  """
  @spec exchange_info_filter(String.t()) :: {:ok, map} | {:error, String.t()}
  def exchange_info_filter(pair) do
    with [informations] <- Enum.filter(load_exchange_info(), &(&1["symbol"] == pair)) do
      info =
        Enum.reduce(informations["filters"], %{}, fn
          %{"filterType" => "PRICE_FILTER"} = filter, acc ->
            Map.merge(acc, %{price: filter})

          %{"filterType" => "LOT_SIZE"} = filter, acc ->
            Map.merge(acc, %{quantity: filter})

          _, acc ->
            acc
        end)

      {:ok, info}
    else
      _ -> {:error, "#{pair} not found in exchange info"}
    end
  end

  @doc false
  def right_quantity?(quantity, %{quantity: info}) do
    max = String.to_float(info["maxQty"])
    min = String.to_float(info["minQty"])
    quantity >= min and quantity <= max
  end

  @doc false
  def trim_quantity(quantity, %{quantity: info}) do
    decimal = String.to_float(info["stepSize"])
    [_a, decimal] = String.split("#{decimal}", ".")

    case decimal == "0" do
      true ->
        trunc(quantity) * 1.0

      false ->
        step_size = String.length(decimal)
        Float.floor(quantity, step_size)
    end
  end

  @doc false
  def right_price?(price, %{price: info}) do
    max = String.to_float(info["maxPrice"])
    min = String.to_float(info["minPrice"])
    price >= min and price <= max
  end

  @doc false
  def trim_price(price, %{price: info}) do
    decimal = String.to_float(info["tickSize"])
    [_a, decimal] = String.split("#{decimal}", ".")

    case decimal == "0" do
      true ->
        trunc(price) * 1.0

      false ->
        step_size = String.length(decimal)
        Float.floor(price, step_size)
    end
  end

  @doc """
  TODO
  """
  def save_trade_from_oco(symbol, price_bought, [order_1, order_2]) do
    orders =
      case order_1["price"] > order_2["price"] do
        true -> %{tp: order_1, stop: order_2}
        false -> %{tp: order_2, stop: order_1}
      end

    save_trade(%{
      price: price_bought,
      symbol: symbol,
      stop_loss_order_id: "#{orders.stop["orderId"]}",
      take_profit_order_id: "#{orders.tp["orderId"]}"
    })
  end

  defp oco_order(
         %RM{
           stop_loss: stop_loss,
           limit: limit,
           quantity: quantity,
           pair: pair,
           pair_price: pair_price
         },
         tp
       ) do
    with {_atom, true} <- {:price, pair_price > stop_loss},
         {_atom, true} <- {:stop, stop_loss > limit},
         {_atom, true} <- {:tp, tp > pair_price} do
      @api.create_oco_order(pair, "SELL", quantity, tp, stop_loss, limit)
    else
      {:price, false} -> {:error, "Sell part: price < stop"}
      {:stop, false} -> {:error, "Sell part: stop < limit"}
      {:tp, false} -> {:error, "Sell part: tp < price"}
    end
  end

  @doc """
  Saves a trade. Check:
    - if stop_loss_order_id and take_profit_order_id exist 
    - if there are the same quantity

  # Examples

     iex> create_trade(
       %{
        stop_loss_order_id: "1",
        take_profit_order_id: "1",
        price: 1.0,
        symbol: "SOLUSDT",
        })
      {:ok, %Trade{}}
  """
  def save_trade(%{
        stop_loss_order_id: stop_loss_order_id,
        take_profit_order_id: take_profit_order_id,
        price: price,
        symbol: symbol
      }) do
    {:ok, orders} = @api.get_open_orders(symbol)

    stop_loss = Enum.find(orders, &(&1.order_id == String.to_integer(stop_loss_order_id)))
    take_profit = Enum.find(orders, &(&1.order_id == String.to_integer(take_profit_order_id)))

    case stop_loss.orig_qty == take_profit.orig_qty do
      false ->
        {:error, "quantities are not the same"}

      true ->
        Data.create_trade(%{
          symbol: symbol,
          quantity: stop_loss.orig_qty,
          stop_loss: stop_loss.price,
          stop_loss_order_id: stop_loss_order_id,
          take_profit: take_profit.price,
          take_profit_order_id: take_profit_order_id,
          side: take_profit.side,
          price: price,
          platform: "binance"
        })
    end
  end
end
