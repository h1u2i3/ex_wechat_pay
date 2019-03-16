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
    demo_all = ExWechatPay.DemoPay.all_fields("/pay/demo")
    demo_required = ExWechatPay.DemoPay.required_fields("/pay/demo")

    assert demo_all == @required ++ @optional
    assert demo_required == @required
  end

  test "should show reason when miss keys" do
    {:error, reason} = ExWechatPay.DemoPay.render("/pay/demo", %{})

    assert reason == "Missed post body required keys: body out_trade_no"
  end

  test "should generate the right post body" do
    {:ok, body} = ExWechatPay.DemoPay.render("/pay/demo", @valid_map)

    assert "<xml>" <> _rest = body
  end
end
