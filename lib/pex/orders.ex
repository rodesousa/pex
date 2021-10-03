defmodule Pex.Orders do
  alias Pex.Trade.Order
  alias Pex.Repo
  import Ecto.Query, warn: false

  @doc ~S"""
  Gets all orders

  ## Examples

      iex> list_orders()
      []
  """
  def list_orders do
    Repo.all(Order)
  end

  @doc ~S"""
  Creates an order

  ## Examples
      
      iex> create_order(%{symbol: "BTCUSDT", quantity: "1", side: "BUY", platform: "binance"})
      {:ok, %Order{}}

      iex> create_order(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(params) do
    %Order{}
    |> Order.changeset(params)
    |> Repo.insert()
  end

  @doc ~S"""
  Deletes all orders

  ## Examples

      iex> delete_orders()
      {0, nil}

  """
  def delete_orders() do
    Repo.delete_all(Order)
  end

  @doc """
  Deletes a order

  ## Examples

      iex> delete_order(1)
      {:ok, %Pex.Trade.Order{}}

  """
  def delete_order(id) do
    Repo.get(Order, id)
    |> Repo.delete()
  end

  @doc """
  Updates a %Order{} 

  ## Examples

      iex> Pex.Orders.update_order("1", %{tp_order_id: 1})
      {:ok, %Pex.Trade.Order{}}
  """
  def update_order(order_id, params) do
    Order
    |> Repo.get!(order_id)
    |> Order.changeset(params)
    |> Repo.update()
  end
end
