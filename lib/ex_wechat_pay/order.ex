defmodule ExWechatPay.Order do
  @moduledoc """
    All the other pay need this order module to create or cancel order.
  """
  use ExWechatPay.Api
  @external_resource Path.join(__DIR__, "apis/order")

  def jsapi_params(params) do
    # get prepay params from params
    IO.inspect(params)
    prepay_params = _create_order(params)

    # %{return_code: "FAIL", return_msg: "appid and openid not match"}
    IO.inspect(prepay_params)

    case prepay_params do
      %{return_code: "FAIL"} ->
        {:error, prepay_params.return_msg}

      %{return_code: "SUCCESS"} ->
        # before sign jsapi params
        jsapi_params = %{
          appId: Application.get_env(:ex_wechat_pay, ExWechatPay)[:appid],
          package: "prepay_id=#{prepay_params.prepay_id}",
          nonceStr: prepay_params.nonce_str,
          timeStamp: :os.system_time(:second),
          signType: "MD5"
        }

        # sign the jsapi params
        {:ok, ExWechatPay.Utils.Signature.jsapi_sign(jsapi_params)}
    end
  end

  def refund_order(unique_no, total, refund) do
    _refund_order(%{
      out_trade_no: unique_no,
      out_refund_no: "R#{unique_no}",
      total_fee: total,
      refund_fee: refund
    })
  end
end
