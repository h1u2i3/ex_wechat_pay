defmodule ExWechatPay.ApiTest do
  use ExUnit.Case

  Code.require_file(Path.join(__DIR__, "demo_pay.ex"))

  @required [:appid, :mch_id, :nonce_str, :sign, :body, :out_trade_no]
  @optional [:device_info, :sign_type, :detail, :attach, :fee_type]

  @valid_map %{
    appid: "test",
    mch_id: "test",
    nonce_str: "test",
    sign: "test",
    body: "test",
    out_trade_no: "test"
  }

  test "should generate right method" do
    demo_all = ExWechatPay.DemoPay._pay_demo
    demo_required = ExWechatPay.DemoPay._pay_demo_required
    demo_optional = ExWechatPay.DemoPay._pay_demo_optional

    assert demo_all == @required ++ @optional
    assert demo_required == @required
    assert demo_optional == @optional
  end

  test "should show reason when miss keys" do
    {:error, reason} = ExWechatPay.DemoPay.render("/pay/demo", %{})

    assert reason ==  "still need post body keys: appid mch_id body out_trade_no"
  end

  test "should generate the right post body" do
    {:ok, body} = ExWechatPay.DemoPay.render("/pay/demo", @valid_map)

    assert "<xml>" <> _  = body
  end
end
