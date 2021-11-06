use Mix.Config

config :pex, :binance_api, Pex.BinanceAPI
config :pex, :ftx_api, Pex.FtxAPI
config :pex, :kucoin_api, Pex.KucoinAPI

config :logger, :console,
  level: :debug,
  format: "$date $time [$level] $metadata$message\n",
  metadata: [:user_id]

import_config "#{Mix.env()}.exs"
