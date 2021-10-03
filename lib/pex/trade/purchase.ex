# defmodule Pex.Trade.Purchase do
# use Ecto.Schema
# import Ecto.Changeset

# schema "purchases" do
# field(:symbol, :string)
# field(:quantity, :float)
# field(:price, :float)

# has_many(:orders, Pex.Trade.Order)
# end

# @attrs_required [:symbol, :price]
# @attrs [:quantity] ++ @attrs_required

# def changeset(purchase, params \\ %{}) do
# purchase
# |> cast(params, @attrs)
# |> validate_required(@attrs_required)
# end
# end
