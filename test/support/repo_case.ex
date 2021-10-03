defmodule Pex.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Pex.Repo

      import Ecto
      import Ecto.Query
      import Pex.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pex.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Pex.Repo, {:shared, self()})
    end

    :ok
  end
end
