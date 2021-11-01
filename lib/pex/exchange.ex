defmodule Pex.Exchange do
  @moduledoc """
  Behaviour for each exchanges
  """

  @doc """
  Returns account balance
  """
  @callback get_balance() :: float

  @doc """
  List of coins in our portfolio
  """
  @callback coins_list() :: [map]

  @doc """
  List of coins whitout exchange order
  """
  @callback coins_list_without_exchange_order() :: [String.t()]

  @doc """
  Gets coins list without local order
  """
  @callback coins_list_without_trade() :: [map]

  @doc """
   Creates a trade
  """
  @callback create_trade(map) :: {:ok, %Pex.Data.Trade{}} | {:error, %Ecto.Changeset{}}

  @doc """
   Creates a trade with shad strategy
  """
  @callback create_shad(map) :: {:ok, %Pex.Data.Trade{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Places a order market buy
  """
  @callback market_buy(String.t(), float, float, float) :: [map]
end
