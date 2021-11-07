defmodule Pex.MockFtxAPI do
  @impl Pex.Exchange
  def get_account() do
    {:ok,
     %ExFtx.Account{
       backstop_provider: false,
       collateral: 789.8038336830847,
       free_collateral: 789.8038336029023,
       initial_margin_requirement: 0.1,
       leverage: 10.0,
       liquidating: false,
       maintenance_margin_requirement: 0.03,
       maker_fee: 1.9e-4,
       margin_fraction: nil,
       open_margin_fraction: nil,
       positions: [],
       taker_fee: 6.65e-4,
       total_account_value: 789.8038336830847,
       total_position_size: 0.0,
       username: "blabla"
     }}
  end

  @impl Pex.Exchange
  def coins_list() do
    {:ok,
     [
       %ExFtx.Balance{
         available_without_borrow: 0.10543,
         coin: "RAY",
         free: 0.10543,
         spot_borrow: 0.0,
         total: 0.10543,
         usd_value: 0.9801300440232065
       },
       %ExFtx.Balance{
         available_without_borrow: 0.25876054,
         coin: "FIDA",
         free: 0.25876054,
         spot_borrow: 0.0,
         total: 0.25876054,
         usd_value: 1.5427756513811623
       },
       %ExFtx.Balance{
         available_without_borrow: 5.5155e-4,
         coin: "FIDA_LOCKED",
         free: 5.5155e-4,
         spot_borrow: 0.0,
         total: 5.5155e-4,
         usd_value: 0.0032888430105
       },
       %ExFtx.Balance{
         available_without_borrow: 0.0052785,
         coin: "SOL",
         free: 4.57231501,
         spot_borrow: 0.0,
         total: 0.0052785,
         usd_value: 0.74642501776761
       },
       %ExFtx.Balance{
         available_without_borrow: 725.12985951,
         coin: "BAO",
         free: 725.12985951,
         spot_borrow: 0.0,
         total: 725.12985951,
         usd_value: 0.2073073755366541
       },
       %ExFtx.Balance{
         available_without_borrow: 0.089037,
         coin: "TOMO",
         free: 288.95865293,
         spot_borrow: 0.0,
         total: 0.089037,
         usd_value: 0.18812077659414
       },
       %ExFtx.Balance{
         available_without_borrow: 0.960765,
         coin: "OXY",
         free: 0.960765,
         spot_borrow: 0.0,
         total: 0.960765,
         usd_value: 2.0420888290218
       },
       %ExFtx.Balance{
         available_without_borrow: 0.98936,
         coin: "MTA",
         free: 0.98936,
         spot_borrow: 0.0,
         total: 0.98936,
         usd_value: 0.6527725947144
       },
       %ExFtx.Balance{
         available_without_borrow: 0.912885,
         coin: "HXRO",
         free: 0.912885,
         spot_borrow: 0.0,
         total: 0.912885,
         usd_value: 0.3990220335
       },
       %ExFtx.Balance{
         available_without_borrow: 0.978055,
         coin: "SRM",
         free: 0.978055,
         spot_borrow: 0.0,
         total: 0.978055,
         usd_value: 7.0842692193546
       },
       %ExFtx.Balance{
         available_without_borrow: 0.0095079,
         coin: "MEDIA",
         free: 0.0095079,
         spot_borrow: 0.0,
         total: 0.0095079,
         usd_value: 0.44782209
       },
       %ExFtx.Balance{
         available_without_borrow: 0.0098936,
         coin: "AAVE",
         free: 2.26126004,
         spot_borrow: 0.0,
         total: 0.0098936,
         usd_value: 2.831292136704576
       },
       %ExFtx.Balance{
         available_without_borrow: 0.974065,
         coin: "ZRX",
         free: 0.974065,
         spot_borrow: 0.0,
         total: 0.974065,
         usd_value: 0.9698723515018
       },
       %ExFtx.Balance{
         available_without_borrow: 8.1712e-4,
         coin: "ROOK",
         free: 8.1712e-4,
         spot_borrow: 0.0,
         total: 8.1712e-4,
         usd_value: 0.10739130741333
       },
       %ExFtx.Balance{
         available_without_borrow: 331.14758883,
         coin: "USD",
         free: 748.29059248,
         spot_borrow: 0.0,
         total: 331.14758883,
         usd_value: 331.1475888342361
       },
       %ExFtx.Balance{
         available_without_borrow: 425.05140273,
         coin: "USDT",
         free: 757.77429226,
         spot_borrow: 0.0,
         total: 425.05140273,
         usd_value: 425.1590937586075
       },
       %ExFtx.Balance{
         available_without_borrow: 0.0,
         coin: "FTT",
         free: 0.0,
         spot_borrow: 0.0,
         total: 0.0,
         usd_value: 0.0
       },
       %ExFtx.Balance{
         available_without_borrow: 9.981e-4,
         coin: "YFI",
         free: 0.01894042,
         spot_borrow: 0.0,
         total: 9.981e-4,
         usd_value: 34.541395491298374
       },
       %ExFtx.Balance{
         available_without_borrow: 0.0,
         coin: "DYDX",
         free: 0.0,
         spot_borrow: 0.0,
         total: 0.0,
         usd_value: 0.0
       },
       %ExFtx.Balance{
         available_without_borrow: 0.0,
         coin: "BTC",
         free: 0.01231212,
         spot_borrow: 0.0,
         total: 0.0,
         usd_value: 0.0
       }
     ]}
  end

  def get_conditional_orders() do
    {:ok,
     [
       # %ExFtx.OrderConditional{
       %{
         filled_size: 0.0,
         id: 89_128_119,
         market: "SOL/USDT",
         order_price: 160.5475,
         order_type: "limit",
         reduce_only: false,
         retry_until_filled: false,
         side: "sell",
         size: 2.84,
         status: "open",
         trigger_price: 120.0,
         type: "stop"
       }
     ]}
  end

  def get_balance,
    do:
      {:ok,
       [
         %ExFtx.Balance{
           available_without_borrow: 0.10543,
           coin: "RAY",
           free: 0.10543,
           spot_borrow: 0.0,
           total: 0.10543,
           usd_value: 1.2953130447877281
         },
         %ExFtx.Balance{
           available_without_borrow: 0.25876054,
           coin: "FIDA",
           free: 0.25876054,
           spot_borrow: 0.0,
           total: 0.25876054,
           usd_value: 2.578066948983198
         },
         %ExFtx.Balance{
           available_without_borrow: 5.5155e-4,
           coin: "FIDA_LOCKED",
           free: 5.5155e-4,
           spot_borrow: 0.0,
           total: 5.5155e-4,
           usd_value: 0.0054861189315
         },
         %ExFtx.Balance{
           available_without_borrow: 0.0,
           coin: "SOL",
           free: 2.21026676,
           spot_borrow: 0.0,
           total: 0.0,
           usd_value: 0.0
         },
         %ExFtx.Balance{
           available_without_borrow: 725.12985951,
           coin: "BAO",
           free: 725.12985951,
           spot_borrow: 0.0,
           total: 725.12985951,
           usd_value: 0.23945963350753535
         },
         %ExFtx.Balance{
           available_without_borrow: 0.089037,
           coin: "TOMO",
           free: 201.34739597,
           spot_borrow: 0.0,
           total: 0.089037,
           usd_value: 0.23352883279596
         },
         %ExFtx.Balance{
           available_without_borrow: 0.960765,
           coin: "OXY",
           free: 0.960765,
           spot_borrow: 0.0,
           total: 0.960765,
           usd_value: 2.23249562902665
         },
         %ExFtx.Balance{
           available_without_borrow: 0.98936,
           coin: "MTA",
           free: 0.98936,
           spot_borrow: 0.0,
           total: 0.98936,
           usd_value: 0.9894033042872
         },
         %ExFtx.Balance{
           available_without_borrow: 0.912885,
           coin: "HXRO",
           free: 0.912885,
           spot_borrow: 0.0,
           total: 0.912885,
           usd_value: 0.4364503185
         },
         %ExFtx.Balance{
           available_without_borrow: 9.978055,
           coin: "SRM",
           free: 9.978055,
           spot_borrow: 0.0,
           total: 9.978055,
           usd_value: 77.2925129340942
         },
         %ExFtx.Balance{
           available_without_borrow: 0.0095079,
           coin: "MEDIA",
           free: 0.0095079,
           spot_borrow: 0.0,
           total: 0.0095079,
           usd_value: 0.43546182
         },
         %ExFtx.Balance{
           available_without_borrow: 0.0098936,
           coin: "AAVE",
           free: 1.77892414,
           spot_borrow: 0.0,
           total: 0.0098936,
           usd_value: 3.11392279479468
         },
         %ExFtx.Balance{
           available_without_borrow: 0.974065,
           coin: "ZRX",
           free: 0.974065,
           spot_borrow: 0.0,
           total: 0.974065,
           usd_value: 1.17588500476205
         },
         %ExFtx.Balance{
           available_without_borrow: 8.1712e-4,
           coin: "ROOK",
           free: 8.1712e-4,
           spot_borrow: 0.0,
           total: 8.1712e-4,
           usd_value: 0.20473435064170875
         },
         %ExFtx.Balance{
           available_without_borrow: 4.69024443,
           coin: "USD",
           free: 621.6259888,
           spot_borrow: 0.0,
           total: 4.69024443,
           usd_value: 4.690244434003677
         },
         %ExFtx.Balance{
           available_without_borrow: 497.31691138,
           coin: "USDT",
           free: 672.70863334,
           spot_borrow: 0.0,
           total: 497.31691138,
           usd_value: 497.7231596270275
         },
         %ExFtx.Balance{
           available_without_borrow: 0.0,
           coin: "FTT",
           free: 0.0,
           spot_borrow: 0.0,
           total: 0.0,
           usd_value: 0.0
         },
         %ExFtx.Balance{
           available_without_borrow: 9.981e-4,
           coin: "YFI",
           free: 0.01721348,
           spot_borrow: 0.0,
           total: 9.981e-4,
           usd_value: 32.920697366742786
         },
         %ExFtx.Balance{
           available_without_borrow: 0.0,
           coin: "DYDX",
           free: 0.0,
           spot_borrow: 0.0,
           total: 0.0,
           usd_value: 0.0
         },
         %ExFtx.Balance{
           available_without_borrow: 0.0,
           coin: "BTC",
           free: 0.0099532,
           spot_borrow: 0.0,
           total: 0.0,
           usd_value: 0.0
         },
         %ExFtx.Balance{
           available_without_borrow: 250.0,
           coin: "CHZ",
           free: 250.0,
           spot_borrow: 0.0,
           total: 250.0,
           usd_value: 122.5554625
         },
         %ExFtx.Balance{
           available_without_borrow: 6.4,
           coin: "ALICE",
           free: 6.4,
           spot_borrow: 0.0,
           total: 6.4,
           usd_value: 90.915395264
         },
         %ExFtx.Balance{
           available_without_borrow: 22.0,
           coin: "AUDIO",
           free: 22.0,
           spot_borrow: 0.0,
           total: 22.0,
           usd_value: 55.33768438
         },
         %ExFtx.Balance{
           available_without_borrow: 23.8,
           coin: "HGET",
           free: 23.8,
           spot_borrow: 0.0,
           total: 23.8,
           usd_value: 116.144
         },
         %ExFtx.Balance{
           available_without_borrow: 947.0,
           coin: "TRX",
           free: 5771.7869375,
           spot_borrow: 0.0,
           total: 947.0,
           usd_value: 95.8776892
         }
       ]}

  def get_balance! do
    {:ok, result} = get_balance()
    result
  end

  def get_price(pair),
    do:
      {:ok,
       %ExFtx.Market{
         ask: 256.1,
         base_currency: "SOL",
         bid: 256.0075,
         change_1h: nil,
         change_24h: nil,
         change_bod: 0.08691961633138104,
         enabled: true,
         high_leverage_fee_exempt: true,
         last: 256.1225,
         min_provide_size: 0.01,
         name: "SOL/USDT",
         post_only: false,
         price: 256.1,
         price_increment: 0.0025,
         quote_currency: "USDT",
         quote_volume_24h: nil,
         restricted: false,
         size_increment: 0.01,
         type: "spot",
         underlying: nil,
         volume_usd_24h: nil
       }}
end
