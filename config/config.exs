use Mix.Config

config :pex, :binance_api, Pex.BinanceAPI
config :pex, :ftx_api, Pex.FtxAPI
config :pex, :kucoin_api, Pex.KucoinAPI

import_config "#{Mix.env()}.exs"
