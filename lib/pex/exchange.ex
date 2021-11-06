defmodule Pex.Exchange do
  @moduledoc """
  Behaviour for each exchanges
  """

  @doc """
  Returns account balance
  """
  @callback get_balance() :: float

  # @doc """
  # List of coins in our portfolio
  # """
  # @callback coins_list() :: [map]

  # @doc """
  # List of coins whitout exchange order
  # """
  # @callback coins_list_without_exchange_order() :: [String.t()]

  # @doc """
  # Gets coins list without local order
  # """
  # @callback coins_list_without_trade() :: [map]

  # @doc """
  # Creates a trade
  # """
  # @callback create_trade(map) :: {:ok, %Pex.Data.Trade{}} | {:error, %Ecto.Changeset{}}

  # @doc """
  # Creates a trade with shad strategy
  # """
  # @callback create_shad(map) :: {:ok, %Pex.Data.Trade{}} | {:error, %Ecto.Changeset{}}

  # @doc """
  # Places a order market buy
  # """
  # @callback market_buy(String.t(), float, float, float) :: [map]

  @doc """
  Loads exchange info from fixture/filename
  """
  @spec load_exchange_from_file!(String.t()) :: map()
  def load_exchange_from_file!(filename) do
    File.read!("fixture/#{filename}")
    |> Jason.decode!()
  end

  @doc """
  Writes in fixture/filename all necessary info (data) to buy on a exchange
  """
  @spec save_exchange_to_file!(String.t(), map) :: :ok
  def save_exchange_to_file!(filename, data) do
    data = Jason.encode!(data)
    File.write!("fixture/#{filename}", data)
  end

  @doc """
  Return a truncated number with the same decimal number of &2

  # Examples

      iex> trunc(10.945, 0.01)
      10.94
  """
  @spec trunc(float, String.t()) :: float
  def trunc(price, filter) do
    decimal = String.to_float(filter)
    [_a, decimal] = String.split("#{decimal}", ".")

    case decimal == "0" do
      true ->
        trunc(price) * 1.0

      false ->
        price
        |> Float.floor(String.length(decimal))
    end
  end
end
