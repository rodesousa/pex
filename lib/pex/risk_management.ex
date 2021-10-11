defmodule Pex.RiskManagement do
  @moduledoc """
  Risk Management module
  """

  @decrease_rate 0.005

  defp position_size(balance, risk, distance) do
    balance * (risk / 100) / (distance / 100)
  end

  @doc """
  Returns position size and how many coins to buy 
  """
  @spec computes_risk(map) :: String.t()
  def computes_risk(%{
        balance: balance,
        risk: risk,
        distance: distance,
        coin_price: coin_price,
        future: future
      }) do
    position =
      position_size(balance, risk, distance) /
        future

    coin = Float.ceil(position / coin_price, 2)
    cost = Float.ceil(coin * coin_price, 2)

    stop_loss = computes_stop_loss(coin_price, distance)

    %{
      quantity: coin * future,
      cost: cost,
      position_size: position,
      stop_loss: stop_loss
    }
  end

  def computes_stop_loss(price, distance) do
    stop_loss = Float.round(price - price * (distance / 100), decimal_size(price))

    if stop_loss == 0.0,
      do: Float.round(price - price * (distance / 100), decimal_size(price) + 1),
      else: stop_loss
  end

  @doc """
  Computes limit from stop
  """
  @spec computes_limit_from_stop(float()) :: {:ok, float()} | {:error, String.t()}
  def computes_limit_from_stop(stop_loss) do
    limit = Float.floor(stop_loss - stop_loss * @decrease_rate, decimal_size(stop_loss))

    if limit == 0.0,
      do: Float.round(stop_loss - stop_loss * @decrease_rate, decimal_size(stop_loss) + 1),
      else: limit
  end

  defp decimal_size(float) do
    length =
      (float - Float.floor(float))
      |> Float.to_string()
      |> String.length()
      |> (&(&1 - 2)).()

    cond do
      float >= 1.0 -> 2
      length > 4 -> min(length, 8)
      true -> 4
    end
  end
end
