defmodule Pex.KucoinExchange do
  def creds() do
    if System.get_env("KUCOIN_API_KEY") == "" or System.get_env("KUCOIN_SECRET_KEY") == "" or
         "KUCOIN_API_PASSPHRASE" == "" do
      {:error, "You have to set KUCOIN_API_KEY and KUCOIN_SECRET_KEY KUCOIN_API_PASSPHRASE"}
    else
      Application.put_env(:ex_kucoin, :api_key, System.get_env("KUCOIN_API_KEY"))
      Application.put_env(:ex_kucoin, :api_secret, System.get_env("KUCOIN_API_SECRET"))
      Application.put_env(:ex_kucoin, :api_passphrase, System.get_env("KUCOIN_API_PASSPHRASE"))
    end
  end
end
