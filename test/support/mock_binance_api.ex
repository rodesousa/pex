defmodule Pex.MockBinanceAPI do
  @behaviour Pex.BinanceAPIBehaviour

  @impl Pex.BinanceAPIBehaviour
  def get_price(_symbol), do: {:ok, %{price: "40.0"}}

  @impl Pex.BinanceAPIBehaviour
  def get_account() do
    {:ok,
     %Binance.Account{
       balances: [
         %{"asset" => "BTC", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "LTC", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "ETH", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "NEO", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "BNB", "free" => "0.02111868", "locked" => "0.00000000"},
         %{"asset" => "QTUM", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "EOS", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "SNT", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "BNT", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "GAS", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "BCC", "free" => "0.00000000", "locked" => "0.00000000"},
         %{"asset" => "USDT", "free" => "1354.60164481", "locked" => "0.00000000"},
         %{"asset" => "HSR", "free" => "0.00000000", "locked" => "0.00000000"}
       ]
     }}
  end

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders() do
    {:ok,
     [
       %Binance.Order{
         client_order_id: "U4c9aYrFBN9LLaJYuYCMAj",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: false,
         order_id: 122_658_018,
         orig_qty: "348.00000000",
         price: "0.12000000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.12660000",
         symbol: "AIONUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "STOP_LOSS_LIMIT"
       },
       %Binance.Order{
         client_order_id: "qOzBJZiNkG4v8xpYx7eeQI",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: true,
         order_id: 122_658_019,
         orig_qty: "348.00000000",
         price: "0.24120000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.00000000",
         symbol: "AIONUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "LIMIT_MAKER",
         update_time: 1_633_718_322_141
       },
       %Binance.Order{
         client_order_id: "w84jKhDTTf3TUkDyVIzAuB",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: true,
         order_id: 31_119_230,
         orig_qty: "46.00000000",
         price: "6.39600000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.00000000",
         symbol: "MIRUSDT",
         time: 1_633_711_315_631,
         time_in_force: "GTC",
         type: "LIMIT",
         update_time: 1_633_711_315_631
       }
     ]}
  end

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders("SUSHIUSDT") do
    {:ok,
     [
       %Binance.Order{
         client_order_id: "U4c9aYrFBN9LLaJYuYCMAj",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: false,
         order_id: 122_658_018,
         orig_qty: "358.00000000",
         price: "0.12000000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.12660000",
         symbol: "SUSHIUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "STOP_LOSS_LIMIT",
         update_time: 1_633_718_322_141
       },
       %Binance.Order{
         client_order_id: "qOzBJZiNkG4v8xpYx7eeQI",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: true,
         order_id: 122_658_019,
         orig_qty: "349.00000000",
         price: "0.24120000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.00000000",
         symbol: "SUSHIUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "LIMIT_MAKER",
         update_time: 1_633_718_322_141
       }
     ]}
  end

  @impl Pex.BinanceAPIBehaviour
  def get_open_orders(_symbol) do
    {:ok,
     [
       %Binance.Order{
         client_order_id: "U4c9aYrFBN9LLaJYuYCMAj",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: false,
         order_id: 122_658_018,
         orig_qty: "348.00000000",
         price: "0.12000000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.12660000",
         symbol: "AIONUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "STOP_LOSS_LIMIT",
         update_time: 1_633_718_322_141
       },
       %Binance.Order{
         client_order_id: "qOzBJZiNkG4v8xpYx7eeQI",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: true,
         order_id: 122_658_019,
         orig_qty: "348.00000000",
         price: "0.24120000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.00000000",
         symbol: "AIONUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "LIMIT_MAKER",
         update_time: 1_633_718_322_141
       },
       %Binance.Order{
         client_order_id: "HchDZoH2TjS84HnS36XABf",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: false,
         order_id: 383_059_912,
         orig_qty: "171.00000000",
         price: "2.79000000",
         side: "SELL",
         status: "NEW",
         stop_price: "2.80000000",
         symbol: "CRVUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "STOP_LOSS_LIMIT",
         update_time: 1_633_718_322_141
       },
       %Binance.Order{
         client_order_id: "asRMGrBDIohoeSpnGjrEBU",
         cummulative_quote_qty: "0.00000000",
         executed_qty: "0.00000000",
         iceberg_qty: "0.00000000",
         is_working: true,
         order_id: 383_059_913,
         orig_qty: "171.00000000",
         price: "3.44000000",
         side: "SELL",
         status: "NEW",
         stop_price: "0.00000000",
         symbol: "CRVUSDT",
         time: 1_633_718_322_141,
         time_in_force: "GTC",
         type: "LIMIT_MAKER",
         update_time: 1_633_718_322_141
       },
       %Binance.Order{
         client_order_id: "7AgUXTxvjHxia9m8NWtqXr",
         order_id: 33_820_595,
         orig_qty: "50.00000000",
         price: "4.00000000",
         side: "SELL",
         status: "NEW",
         symbol: "POLSUSDT",
         time_in_force: "GTC",
         type: "LIMIT"
       }
     ]}
  end

  @impl Pex.BinanceAPIBehaviour
  def order_market_buy(symbol, quantity) do
    {:ok,
     %{
       "clientOrderId" => "HDs4nqCgLGKUnOezL5TstX",
       "cummulativeQuoteQty" => "96.33360000",
       "executedQty" => "123.00000000",
       "fills" => [
         %{
           "commission" => "0.00017121",
           "commissionAsset" => "BNB",
           "price" => "0.78320000",
           "qty" => "123.00000000",
           "tradeId" => 28_180_742
         }
       ],
       "orderId" => 420_453_896,
       "orderListId" => -1,
       "origQty" => "123.00000000",
       "price" => "0.00000000",
       "side" => "BUY",
       "status" => "FILLED",
       "symbol" => "FETUSDT",
       "timeInForce" => "GTC",
       "transactTime" => 1_633_821_564_090,
       "type" => "MARKET"
     }}
  end

  @impl Pex.BinanceAPIBehaviour
  def order_limit_sell(symbol, quantity, tp) do
    {:ok,
     %Binance.OrderResponse{
       client_order_id: "7AgUXTxvjHxia9m8NWtqXr",
       executed_qty: "0.00000000",
       order_id: 33_820_595,
       orig_qty: "50.00000000",
       price: "4.00000000",
       side: "SELL",
       status: "NEW",
       symbol: "POLSUSDT",
       time_in_force: "GTC",
       transact_time: 1_633_821_747_353,
       type: "LIMIT"
     }}
  end

  @impl Pex.BinanceAPIBehaviour
  def create_oco_order(symbol, side, quantity, tp, stop, limit) do
    {:ok,
     %{
       "contingencyType" => "OCO",
       "listClientOrderId" => "5Cm8cc5EzHcWDDsGn7XKnk",
       "listOrderStatus" => "EXECUTING",
       "listStatusType" => "EXEC_STARTED",
       "orderListId" => 47_500_294,
       "orderReports" => [
         %{
           "clientOrderId" => "HchDZoH2TjS84HnS36XABf",
           "cummulativeQuoteQty" => "0.00000000",
           "executedQty" => "0.00000000",
           "orderId" => 383_059_912,
           "orderListId" => 47_500_294,
           "origQty" => "171.00000000",
           "price" => "2.79000000",
           "side" => "SELL",
           "status" => "NEW",
           "stopPrice" => "2.80000000",
           "symbol" => "CRVUSDT",
           "timeInForce" => "GTC",
           "transactTime" => 1_633_820_242_709,
           "type" => "STOP_LOSS_LIMIT"
         },
         %{
           "clientOrderId" => "asRMGrBDIohoeSpnGjrEBU",
           "cummulativeQuoteQty" => "0.00000000",
           "executedQty" => "0.00000000",
           "orderId" => 383_059_913,
           "orderListId" => 47_500_294,
           "origQty" => "171.00000000",
           "price" => "3.44000000",
           "side" => "SELL",
           "status" => "NEW",
           "symbol" => "CRVUSDT",
           "timeInForce" => "GTC",
           "transactTime" => 1_633_820_242_709,
           "type" => "LIMIT_MAKER"
         }
       ],
       "orders" => [
         %{
           "clientOrderId" => "HchDZoH2TjS84HnS36XABf",
           "orderId" => 383_059_912,
           "symbol" => "CRVUSDT"
         },
         %{
           "clientOrderId" => "asRMGrBDIohoeSpnGjrEBU",
           "orderId" => 383_059_913,
           "symbol" => "CRVUSDT"
         }
       ],
       "symbol" => "CRVUSDT",
       "transactionTime" => 1_633_820_242_709
     }}
  end
end
