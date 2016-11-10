defmodule ExWechatPay.DemoPay do
  use ExWechatPay.Api

  def validate_post_body(_path, post_map) do
    {:ok, post_map}
  end

  def endpoint do
    "https://api.mch.weixin.qq.com"
  end
end
