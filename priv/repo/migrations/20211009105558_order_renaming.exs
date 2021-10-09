defmodule Pex.Repo.Migrations.OrderRenaming do
  use Ecto.Migration

  def change do
    rename(table(:orders), to: table(:trades))
  end
end
