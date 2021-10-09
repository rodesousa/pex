defmodule Pex.Exchange do
  @moduledoc """
  Behaviour for each exchanges
  """

  @doc """
  Set exchange credentials
  """
  @callback creds() :: :ok | {:error, String.t()}
end
