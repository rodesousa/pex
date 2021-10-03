defmodule Pex.ExchangeBehavior do
  alias Pex.Trade.Order

  @doc """
  Returns coins list
  """
  @callback coins_list() :: [%Order{}]

  @doc """
  Returns [%Order{}] if there are exchange orders that are not exist in db
  """
  @callback synchronize_orders() :: :ok
end
