defmodule Pex.Repo.Migrations.Initdb do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:symbol, :string)
      add(:type, :string)
      add(:quantity, :float)
      add(:price, :float)
      add(:take_profit, :float)
      add(:stop_loss, :float)
      add(:side, :string)
      add(:platform, :string)
      add(:take_profit_order_id, :string)
      add(:stop_loss_order_id, :string)

      timestamps()
    end

    create(index(:orders, [:symbol]))
  end
end
