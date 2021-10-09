defmodule Pex.Data do
  alias Pex.Data.Trade
  alias Pex.Repo
  import Ecto.Query, warn: false

  @doc ~S"""
  Gets all orders

  ## Examples

      iex> list_trades()
      [%Trade{}, ...]
  """
  def list_trades do
    Repo.all(Trade)
  end

  @doc ~S"""
  Creates a trade

  ## Examples
      
      iex> create_trade(%{symbol: "BTCUSDT", quantity: "1", side: "BUY", platform: "binance"})
      {:ok, %Trade{}}

      iex> create_trade(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_trade(params) do
    %Trade{}
    |> Trade.changeset(params)
    |> Repo.insert()
  end

  @doc ~S"""
  Deletes all orders

  ## Examples

      iex> delete_orders()
      {0, nil}

  """
  def delete_orders() do
    Repo.delete_all(Trade)
  end

  @doc """
  Deletes a order

  ## Examples

      iex> delete_order(1)
      {:ok, %Pex.Trade.Order{}}

  """
  def delete_order(id) do
    Repo.get(Trade, id)
    |> Repo.delete()
  end

  @doc """
  Updates a %Trade{} 

  ## Examples

      iex> update_trade("1", %{tp_order_id: 1})
      {:ok, %Pex.Data.Trade{}}
  """
  def update_trade(order_id, params) do
    Trade
    |> Repo.get!(order_id)
    |> Trade.changeset(params)
    |> Repo.update()
  end
end
