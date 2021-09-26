defmodule Pex.Tool.RiskManagement do
  @moduledoc """
  Risk Management module
  """
  alias Pex.Tool.RiskManagement

  defstruct portfolio: 0.0, risk: 0.0, distance: 0.0

  @type t :: %RiskManagement{
          portfolio: float(),
          risk: float(),
          distance: float()
        }

  @doc """
  Calculates position size
  """
  @spec position_size(t()) :: String.t()
  def position_size(risk_management) do
    risk_management.portfolio * (risk_management.risk / 100) / (risk_management.distance / 100)
  end

  @doc """
  Returns position size and how many coins to buy 
  """
  @spec computes_risk(t(), float, float) :: String.t()
  def computes_risk(risk_management, coin_price, future \\ 1) do
    position =
      position_size(risk_management) /
        future

    coin = Float.ceil(position / coin_price, 2)
    price = Float.ceil(coin * coin_price, 2)

    %{
      coin: coin * future,
      price: price,
      position_size: position
    }
  end
end
