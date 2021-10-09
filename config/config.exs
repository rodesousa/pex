use Mix.Config

config :pex, :binance_api, Pex.BinanceAPI

import_config "#{Mix.env()}.exs"
