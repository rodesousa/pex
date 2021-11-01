defmodule Pex.MockKucoinAPI do
  def get_account() do
    {:ok,
     %{
       "code" => "200000",
       "data" => [
         %{
           "available" => "25.07108936",
           "balance" => "25.07108936",
           "currency" => "KCS",
           "holds" => "0",
           "id" => "6030e70c422b690006c1cca1",
           "type" => "trade"
         },
         %{
           "available" => "372.04690325",
           "balance" => "372.04690325",
           "currency" => "USDT",
           "holds" => "0",
           "id" => "6030e6f3e8e521000616b725",
           "type" => "trade"
         },
         %{
           "available" => "13331.49990881",
           "balance" => "26663.00000881",
           "currency" => "NIM",
           "holds" => "13331.5001",
           "id" => "606bb4594027f80006aa11d5",
           "type" => "trade"
         },
         %{
           "available" => "5.41872997",
           "balance" => "5.41872997",
           "currency" => "LYXE",
           "holds" => "0",
           "id" => "616780f3d5a5cf00017b171a",
           "type" => "trade"
         },
         %{
           "available" => "0.00004436",
           "balance" => "170.68154436",
           "currency" => "HTR",
           "holds" => "170.6815",
           "id" => "61677ac97a77220001d37047",
           "type" => "trade"
         },
         %{
           "available" => "100",
           "balance" => "100",
           "currency" => "WOO",
           "holds" => "0",
           "id" => "616207b5b0667e0006d36f31",
           "type" => "trade"
         },
         %{
           "available" => "22.90043166",
           "balance" => "22.90043166",
           "currency" => "1INCH",
           "holds" => "0",
           "id" => "6159699e54d89a000681186a",
           "type" => "trade"
         },
         %{
           "available" => "4.33775324",
           "balance" => "4.33775324",
           "currency" => "CAKE",
           "holds" => "0",
           "id" => "613e5d0df3962a0006db4784",
           "type" => "trade"
         },
         %{
           "available" => "113.66865586",
           "balance" => "113.66865586",
           "currency" => "BAT",
           "holds" => "0",
           "id" => "6167705860dd550001a54d20",
           "type" => "trade"
         },
         %{
           "available" => "86.7690366",
           "balance" => "86.7690366",
           "currency" => "MANA",
           "holds" => "0",
           "id" => "606bb95b1d297c0006e231c5",
           "type" => "trade"
         },
         %{
           "available" => "155.53555571",
           "balance" => "155.53555571",
           "currency" => "CHZ",
           "holds" => "0",
           "id" => "61228d02995cff00064e2007",
           "type" => "trade"
         },
         %{
           "available" => "0.00003125",
           "balance" => "0.00003125",
           "currency" => "KCS",
           "holds" => "0",
           "id" => "60329cb58b42f900063698f7",
           "type" => "main"
         },
         %{
           "available" => "0.00002989",
           "balance" => "0.00002989",
           "currency" => "ERG",
           "holds" => "0",
           "id" => "616777507a77220001cde5ef",
           "type" => "trade"
         },
         %{
           "available" => "0.00000303",
           "balance" => "0.00000303",
           "currency" => "CRPT",
           "holds" => "0",
           "id" => "616774dcc429720001600a5e",
           "type" => "trade"
         }
       ]
     }}
  end

  def get_price("KCS"),
    do: {:ok, %{"code" => "200000", "data" => %{"KCS" => "15.44945491"}}}

  def get_price(%{currencies: "KCS"}),
    do: {:ok, %{"code" => "200000", "data" => %{"KCS" => "15.44945491"}}}

  def get_price(%{currencies: "NIM"}),
    do: {:ok, %{"code" => "200000", "data" => %{"NIM" => "0.00697340"}}}

  def get_price(%{currencies: "LYXE"}),
    do: {:ok, %{"code" => "200000", "data" => %{"LYXE" => "28.04020582"}}}

  def get_price(%{currencies: "HTR"}),
    do: {:ok, %{"code" => "200000", "data" => %{"HTR" => "0.87061293"}}}

  def get_price(%{currencies: "WOO"}),
    do: {:ok, %{"code" => "200000", "data" => %{"WOO" => "1.27375261"}}}

  def get_price(%{currencies: "1INCH"}),
    do: {:ok, %{"code" => "200000", "data" => %{"1INCH" => "3.94060598"}}}

  def get_price(%{currencies: "CAKE"}),
    do: {:ok, %{"code" => "200000", "data" => %{"CAKE" => "19.77502082"}}}

  def get_price(%{currencies: "BAT"}),
    do: {:ok, %{"code" => "200000", "data" => %{"BAT" => "0.70822917"}}}

  def get_price(%{currencies: "MANA"}),
    do: {:ok, %{"code" => "200000", "data" => %{"MANA" => "0.78651134"}}}

  def get_price(%{currencies: "CHZ"}),
    do: {:ok, %{"code" => "200000", "data" => %{"CHZ" => "0.32270773"}}}

  def get_price(%{currencies: "ERG"}),
    do: {:ok, %{"code" => "200000", "data" => %{"ERG" => "9.36706325"}}}

  def get_price(%{currencies: "CRPT"}),
    do: {:ok, %{"code" => "200000", "data" => %{"CRPT" => "0.25702429"}}}

  def get_stop_order do
    {:ok,
     %{
       "code" => "200000",
       "data" => %{
         "currentPage" => 1,
         "items" => [
           %{
             "id" => "vs8hoobhbamf7q3m000tf0eb",
             "price" => "16.90000000000000000000",
             "side" => "sell",
             "size" => "25.07100000000000000000",
             "stop" => "entry",
             "stopPrice" => "16.70000000000000000000",
             "symbol" => "KCS-USDT"
           },
           %{
             "id" => "vs8hoobhb9rf7q3m000tf0dg",
             "price" => "13.60000000000000000000",
             "side" => "sell",
             "size" => "25.07100000000000000000",
             "stop" => "loss",
             "stopPrice" => "13.67000000000000000000",
             "symbol" => "KCS-USDT"
           },
           %{
             "id" => "vsa7cobf9gtf7q3m000td8ba",
             "price" => "1.58000000000000000000",
             "side" => "sell",
             "size" => "100.00000000000000000000",
             "stop" => "entry",
             "stopPrice" => "1.59000000000000000000",
             "symbol" => "WOO-USDT"
           },
           %{
             "id" => "vsa7cobf9gklqol1000ocu12",
             "price" => "0.94600000000000000000",
             "side" => "sell",
             "size" => "100.00000000000000000000",
             "stop" => "loss",
             "stopPrice" => "0.94800000000000000000",
             "symbol" => "WOO-USDT"
           },
           %{
             "id" => "vs8coobf9dtv7q3m000td88m",
             "price" => "34.09000000000000000000",
             "side" => "sell",
             "size" => "5.41870000000000000000",
             "stop" => "entry",
             "stopPrice" => "34.10000000000000000000",
             "symbol" => "LYXE-USDT"
           },
           %{
             "id" => "vs8coobf9dncigjt000v10te",
             "price" => "22.31000000000000000000",
             "side" => "sell",
             "size" => "5.41870000000000000000",
             "stop" => "loss",
             "stopPrice" => "22.32000000000000000000",
             "symbol" => "LYXE-USDT"
           },
           %{
             "id" => "vs9moob7g78lqol1000o70l1",
             "price" => "1.00000000000000000000",
             "side" => "sell",
             "size" => "86.76900000000000000000",
             "stop" => "entry",
             "stopPrice" => "1.07000000000000000000",
             "symbol" => "MANA-USDT"
           },
           %{
             "id" => "vs9moob7g70qm36m000k8mfp",
             "price" => "0.58000000000000000000",
             "side" => "sell",
             "size" => "86.76900000000000000000",
             "stop" => "loss",
             "stopPrice" => "0.58800000000000000000",
             "symbol" => "MANA-USDT"
           },
           %{
             "id" => "vs8coob7g4ecigjt000ur3gk",
             "price" => "34.00000000000000000000",
             "side" => "sell",
             "size" => "5.41870000000000000000",
             "stop" => "entry",
             "stopPrice" => "34.10000000000000000000",
             "symbol" => "LYXE-USDT"
           },
           %{
             "id" => "vs8coob7g44cigjt000ur3g4",
             "price" => "22.30000000000000000000",
             "side" => "sell",
             "size" => "5.41870000000000000000",
             "stop" => "loss",
             "stopPrice" => "22.32000000000000000000",
             "symbol" => "LYXE-USDT"
           },
           %{
             "id" => "vsa2gob7f8hcigjt000ur2od",
             "price" => "62.80000000000000000000",
             "side" => "sell",
             "size" => "1.60140000000000000000",
             "stop" => "loss",
             "stopPrice" => "62.88000000000000000000",
             "symbol" => "HAPI-USDT"
           },
           %{
             "id" => "vs87gob7edjld0e3000n5onb",
             "price" => "0.43000000000000000000",
             "side" => "sell",
             "size" => "155.53550000000000000000",
             "stop" => "entry",
             "stopPrice" => "0.43700000000000000000",
             "symbol" => "CHZ-USDT"
           },
           %{
             "id" => "vs87gob7ed5ld0e3000n5on6",
             "price" => "0.22300000000000000000",
             "side" => "sell",
             "size" => "155.53550000000000000000",
             "stop" => "loss",
             "stopPrice" => "0.23300000000000000000",
             "symbol" => "CHZ-USDT"
           },
           %{
             "id" => "vs9jkob7e84lqol1000o6utn",
             "price" => "16.85000000000000000000",
             "side" => "sell",
             "size" => "4.33770000000000000000",
             "stop" => "loss",
             "stopPrice" => "16.90000000000000000000",
             "symbol" => "CAKE-USDT"
           },
           %{
             "id" => "vs9jkob7e7lcigjt000ur1q1",
             "price" => "26.10000000000000000000",
             "side" => "sell",
             "size" => "4.33770000000000000000",
             "stop" => "entry",
             "stopPrice" => "26.16000000000000000000",
             "symbol" => "CAKE-USDT"
           },
           %{
             "id" => "vs9j0ob7e25sigjt000ur1kq",
             "price" => "0.56500000000000000000",
             "side" => "sell",
             "size" => "113.66860000000000000000",
             "stop" => "loss",
             "stopPrice" => "0.57000000000000000000",
             "symbol" => "BAT-USDT"
           },
           %{
             "id" => "vs9j0ob7e1rsigjt000ur1kl",
             "price" => "1.20000000000000000000",
             "side" => "sell",
             "size" => "113.66860000000000000000",
             "stop" => "entry",
             "stopPrice" => "1.21200000000000000000",
             "symbol" => "BAT-USDT"
           },
           %{
             "id" => "vs9g8ob7dr45d0e3000n5o7k",
             "price" => "2.15000000000000000000",
             "side" => "sell",
             "size" => "22.90040000000000000000",
             "stop" => "loss",
             "stopPrice" => "2.15800000000000000000",
             "symbol" => "1INCH-USDT"
           },
           %{
             "id" => "vs9g8ob7dqkqm36m000k8kd8",
             "price" => "5.39900000000000000000",
             "side" => "sell",
             "size" => "22.90040000000000000000",
             "stop" => "entry",
             "stopPrice" => "5.40000000000000000000",
             "symbol" => "1INCH-USDT"
           }
         ]
       }
     }}
  end

  def new_order(_osef),
    do: {:ok, %{"code" => "200000", "data" => %{"orderId" => "11111"}}}

  def new_stop_order(_osef),
    do: {:ok, %{"code" => "200000", "data" => %{"orderId" => "vsa3gobmum45qol1000ojfav2"}}}
end
