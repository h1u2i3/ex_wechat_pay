defmodule ExWechatPay.PublicPay do
  use ExWechatPay.Api

  def create_order(params) do
    _create_order(params)
  end

  def order(map) do
    struct(Order, map)
  end

end
