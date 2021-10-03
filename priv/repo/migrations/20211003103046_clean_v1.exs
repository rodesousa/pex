defmodule Pex.Repo.Migrations.CleanV1 do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      remove(:type)
    end
  end
end
