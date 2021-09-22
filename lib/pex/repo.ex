defmodule Pex.Repo do
  use Ecto.Repo,
    otp_app: :pex,
    adapter: Ecto.Adapters.Postgres
end
