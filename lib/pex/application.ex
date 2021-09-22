defmodule Pex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Pex.Repo
      # Starts a worker by calling: Pex.Worker.start_link(arg)
      # {Pex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
