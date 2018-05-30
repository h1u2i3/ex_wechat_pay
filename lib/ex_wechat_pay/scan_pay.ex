defmodule ExWechatPay.ScanPay do
  import ExWechatPay.Order, only: [_create_order: 1]

  def pay_url(params) do
    params
    |> Map.put(:trade_type, "NATIVE")
    |> _create_order
  end
end
