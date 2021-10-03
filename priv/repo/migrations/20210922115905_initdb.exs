defmodule Pex.Repo.Migrations.Initdb do
  use Ecto.Migration

  def change do
    # create table(:purchases) do
    # add(:symbol, :string)
    # add(:quantity, :float)
    # add(:price, :float)
    # timestamps()
    # end

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

      # add(:purchase_id, references(:purchases))
      timestamps()
    end

    # create(index(:purchases, [:symbol]))
    create(index(:orders, [:symbol]))
  end
end
