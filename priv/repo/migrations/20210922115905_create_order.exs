defmodule Pex.Repo.Migrations.CreateOco do
  use Ecto.Migration

  def change do
    create table(:purchases) do
      add(:symbol, :string)
      add(:quantity, :float)
      add(:price, :float)
    end

    create table(:orders) do
      add(:type, :string)
      add(:quantity, :float)
      add(:purchase_id, references(:purchases))
      add(:price, :float)
    end

    create(index(:purchases, [:id]))
    create(index(:orders, [:id]))
  end
end
