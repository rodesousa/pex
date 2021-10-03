defmodule Pex.Orders do
  alias Pex.Trade.Order
  alias Pex.Repo
  import Ecto.Query, warn: false

  @doc ~S"""
  Gets all orders

  ## Examples

      iex> Pex.Trade.list_orders()
      [%Pex.Trade.Order{}]

      iex> Pex.Trade.list_orders()
      []
  """
  def list_orders do
    Repo.all(Order)
  end

  # @doc ~S"""
  # Gets one order

  ### Examples

  # iex> Pex.Trade.get_order("11")
  # %Pex.Trade.Order{}

  # iex> Pex.Trade.get_order("12")
  # nil

  # """
  # def get_order(order_id) do
  # Order
  # |> where([o], o.exchange_order_id == ^order_id)
  # |> Repo.one()
  # end

  @doc ~S"""
  Creates an order

  ## Examples
      
      iex> Pex.Trade.create_order(order)
      {:ok, %Order{}}

      iex> Pex.Trade.create_order(order)
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

      iex> Pex.Trade.delete_orders()
      {1, nil}

  """
  def delete_orders() do
    Repo.delete_all(Order)
  end

  @doc """
  Deletes a order

  ## Examples

      iex> Pex.Orders.delete_order(1)
      {:ok, %Pex.Trade.Order{}}

  """
  def delete_order(id) do
    Repo.get(Order, id)
    |> Repo.delete()
  end

  @doc """
  Updates a %Order{} 

  ## Examples

      iex> update_order("1", %{tp_order_id: 1})
      {:ok, %Order{}}
  """
  def update_order(order_id, params) do
    Order
    |> Repo.get!(order_id)
    |> Order.changeset(params)
    |> Repo.update()
  end
end
