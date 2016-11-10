defmodule ExWechatPay.MicroPay do
  use ExWechatPay.Api
  import ExWechatPay.Order, only: [_query_order: 1, _close_order: 1, _refund_order: 1, _query_refund_order: 1]
  @external_resource Path.join(__DIR__, "apis/micropay")

  def cancel_order(params) do
    _close_order(params)
    _query_order(params)
    _refund_order(params)
    _query_refund_order(params)
  end
end
