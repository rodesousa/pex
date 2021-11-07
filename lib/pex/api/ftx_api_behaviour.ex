defmodule Pex.FtxAPIBehaviour do
  @doc """
  Behavour of /account
  """
  @callback get() :: {:ok, ExFtx.Account.t()}

  @doc """
  List of coins in our portfolio
  """
  @callback coins_list() :: {:ok, [ExFtx.Balance.t()]}
end
