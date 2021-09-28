defmodule Pex.TradeBehavior do
  alias Pex.Trade.Order

  @doc """
  Returns actif order in db
  """
  @callback orders() :: [%Order{}]

  @doc """
  Returns [%Order{}] if there are exchange orders that are not exist in db
  """
  @callback synchronize_orders() :: :ok
end
