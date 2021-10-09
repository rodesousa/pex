# defmodule Pex.Trade do
# @doc """
# Returns the increase or decrease percentage

# When stop_loss is nul this means that is a shad order
# """
# def percent_order(order = %{stop_loss: nil}, current_price),
# do: increase_percent(order, current_price)

# def percent_order(order, current_price) do
# case order.price > current_price do
# true -> decrease_percent(order, current_price)
# false -> increase_percent(order, current_price)
# end
# end

# defp increase_percent(order, current_price) do
# take_profit_percent = percent(order.take_profit, order.price)
# take_profit_factor = factor(take_profit_percent)
# current_percent = percent(current_price, order.price)
# take_profit_factor * current_percent
# end

# defp decrease_percent(order, current_price) do
# stop_loss_percent = percent(order.stop_loss, order.price)
# stop_loss_factor = factor(stop_loss_percent)
# current_percent = percent(current_price, order.price)
# -stop_loss_factor * current_percent
# end

# defp percent(target, begin), do: 100 * ((target - begin) / begin)

# defp factor(percentage), do: 100 / percentage
# end
