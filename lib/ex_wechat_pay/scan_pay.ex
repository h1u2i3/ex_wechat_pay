defmodule ExWechatPay.ScanPay do
  import ExWechatPay.Order, only: [_create_order: 1, _query_order: 1,
                                   _close_order: 1, _refund_order: 1, _query_refund_order: 1]

  def query_order(params) do
    _query_order(params)
  end
end
