defmodule Pex.RiskManagement do
  @moduledoc """
  Risk Management module
  """

  defstruct [
    :distance,
    :stop_loss,
    :quantity,
    :cost,
    :limit,
    :position,
    :pair,
    :pair_price
  ]

  @type t :: %__MODULE__{
          distance: float,
          stop_loss: float,
          quantity: float,
          cost: float,
          limit: float,
          position: float,
          pair: String.t(),
          pair_price: String.t()
        }

  @risk 1
  @decrease_rate 0.003

  @doc """
  Computes and returns a %RiskManagement{}
  """
  @spec computes_risk(map) :: t
  def computes_risk(%{
        balance: balance,
        distance: distance,
        coin_price: coin_price
      }) do
    position = balance * (@risk / 100.0) / (distance / 100.0)
    quantity = position / coin_price
    cost = Float.ceil(quantity * coin_price, 2)
    stop_loss = coin_price - coin_price * (distance / 100.0)
    limit = stop_loss - stop_loss * @decrease_rate

    %__MODULE__{
      quantity: quantity,
      cost: cost,
      distance: distance,
      stop_loss: stop_loss,
      limit: limit,
      position: position
    }
  end

  @doc false
  def decrease(number), do: number * (1 - @decrease_rate)
end
