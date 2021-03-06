import Mix.Config

config :pex, Pex.Repo,
  database: "pex_repo_test",
  username: "user",
  password: "dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :pex, ecto_repos: [Pex.Repo]

config :pex, :binance_api, Pex.MockBinanceAPI
config :pex, :ftx_api, Pex.MockFtxAPI
config :pex, :kucoin_api, Pex.MockKucoinAPI
