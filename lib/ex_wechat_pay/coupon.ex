defmodule ExWechatPay.Coupon do
  use ExWechatPay.Api

  @external_resource Path.join(__DIR__, "apis/coupon")
end
