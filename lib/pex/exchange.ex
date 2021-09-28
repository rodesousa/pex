defmodule Pex.Exchange do
  @moduledoc """
  Behaviour for each exchanges
  """

  alias Pex.Exchange

  defstruct [:symbol, :free, :locked]

  @type t :: %Exchange{
          symbol: String.t(),
          free: float(),
          locked: float()
        }

  @doc """
  Returns all coin of exchange
  """
  @callback coins_list() :: [%Exchange{}]

  @doc """
  Set exchange credentials
  """
  @callback creds() :: :ok | {:error, String.t()}
end
