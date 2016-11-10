defmodule ExWechatPay.Order do
  @moduledoc """
    All the other pay need this order module to create or cancel order.
  """
  use ExWechatPay.Api
  @external_resource Path.join(__DIR__, "apis/public_pay")
end
