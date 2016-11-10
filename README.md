# ExWechatPay

Still in development.

## Installation

If you want to use, the package can be installed as:

  1. Add `ex_wechat_pay` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_wechat_pay, github: "h1u2i3/ex_wechat_pay"}]
    end
    ```

  2. Add config:

    ```elixir
    config :ex_wechat_pay, ExWechatPay,
      appid: "xxxxxx",
      mch_id: "xxxxxx",
      cert: Path.join(__DIR__, "certs/apiclient_cert.pem"),
      cert_key: Path.join(__DIR__, "certs/apiclient_key.pem"),
      appkey: "xxxxxx",
      sandbox: false
    ```

## Usage(If you want to use, because still in development, just import the `_query_order` method, but it should work)

    ```elixir
    iex> ExWechatPay.Order._query_order %{out_trade_no: 1478757610795189}
    %{appid: "wx65fd9eeccd53f1a1", attach: "", bank_type: "CFT", cash_fee: "10000",
      fee_type: "CNY", is_subscribe: "Y", mch_id: "1298302201",
      nonce_str: "KkpefWMxN2MaC7cq", openid: "oq6v8w6l7fgoU4lUJMHBidGPs5Wk",
      out_trade_no: "1478757610795189", result_code: "SUCCESS",
      return_code: "SUCCESS", return_msg: "OK",
      sign: "3CBCEAE15C954951C153C4EAF42C50A9", time_end: "20161110140019",
      total_fee: "10000", trade_state: "SUCCESS", trade_type: "JSAPI",
      transaction_id: "4005592001201611109295481180"}

    iex> ExWechatPay.Order._refund_order %{out_trade_no: 1478763498145955, out_refund_no: "r1478763498145955", total_fee: 1, refund_fee: 1}
    %{appid: "wx65fd9eeccd53f1a1", cash_fee: "1", cash_refund_fee: "1",
      coupon_refund_count: "0", coupon_refund_fee: "0", mch_id: "1298302201",
      nonce_str: "TnnJBufIOIHYfcCx", out_refund_no: "r1478763498145955",
      out_trade_no: "1478763498145955", refund_channel: "", refund_fee: "1",
      refund_id: "2002002001201611100576499990", result_code: "SUCCESS",
      return_code: "SUCCESS", return_msg: "OK",
      sign: "5FEF858AE44F426AB7DB2F69234AFEB1", total_fee: "1",
      transaction_id: "4002002001201611109305117172"}

      iex> ExWechatPay.Order._download_bill_list %{bill_date: "20161109", bill_type: "ALL"}
      "交易时间,公众账号ID,商户号,子商户号,设备号,微信订单号,商户订单号,用户标识,交易类型......"

      iex> ExWechatPay.MicroPay._create_micropay %{out_trade_no: 1478763498820308, total_fee: 1, body: "扫码支付-测试", spbill_create_ip: "58.49.243.37", auth_code: "131209305924009801"}
    %{appid: "wx65fd9eeccd53f1a1", attach: "", bank_type: "CFT", cash_fee: "1",
      fee_type: "CNY", is_subscribe: "Y", mch_id: "1298302201",
      nonce_str: "Id2134ZPGgBmQqO8", openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g",
      out_trade_no: "1478763498820308", result_code: "SUCCESS",
      return_code: "SUCCESS", return_msg: "OK",
      sign: "3D32420E7EFF9E66D9B3A9E254C1E213", time_end: "20161110165437",
      total_fee: "1", trade_type: "MICROPAY",
      transaction_id: "4002002001201611109312466160"}

    iex> ExWechatPay.MicroPay._cancel_micropay %{out_trade_no: 1478763498820308}
    %{appid: "wx65fd9eeccd53f1a1", mch_id: "1298302201",
    nonce_str: "Vh5qHN9khzd9jOoH", recall: "N", result_code: "SUCCESS",
    return_code: "SUCCESS", return_msg: "OK",
    sign: "0377C7E52DB4F3373E2CF1A341E056C0"}

    iex> ExWechatPay.Redpack._send_redpack %{re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", mch_billno: "1298302201201611104565456512", send_name: "测试", total_amount: 1, total_num: 1, wishing: "测试", client_ip: "127.0.0.1", act_name: "测试", remark: "测试"}
    %{err_code: "MONEY_LIMIT",
      err_code_des: "每个红包的平均金额必须在1.00元到200.00元之间.",
      mch_billno: "1298302201201611104565456512", mch_id: "1298302201",
      re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", result_code: "FAIL",
      return_code: "SUCCESS",
      return_msg: "每个红包的平均金额必须在1.00元到200.00元之间.",
      total_amount: "1", wxappid: "wx65fd9eeccd53f1a1"}
    iex> ExWechatPay.Redpack._send_redpack %{re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", mch_billno: "1298302201201611104565456512", send_name: "测试", total_amount: 100, total_num: 1, wishing: "测试", client_ip: "127.0.0.1", act_name: "测 试", remark: "测试"}
    %{err_code: "SUCCESS", err_code_des: "发放成功",
      mch_billno: "1298302201201611104565456512", mch_id: "1298302201",
      re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", result_code: "SUCCESS",
      return_code: "SUCCESS", return_msg: "发放成功",
      send_listid: "1000041701201611103000071793049", total_amount: "100",
      wxappid: "wx65fd9eeccd53f1a1"}
    iex> ExWechatPay.Redpack._send_group_redpack %{re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", mch_billno: "1298302201201611104565455812", send_name: "测试", total_amount: 300, total_num: 4, wishing: "测试", client_ip: "127.0.0.1", act_name: "测试", remark: "测试"}
    {:error, "still need post body keys: amt_type"}
    iex> ExWechatPay.Redpack._send_group_redpack %{re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", mch_billno: "1298302201201611104565455812", send_name: "测试", total_amount: 300, total_num: 4, wishing: "测试", client_ip: "127.0.0.1", act_name: "测试", remark: "测试", amt_type: "ALL_RAND"}
    %{err_code: "MONEY_LIMIT",
      err_code_des: "每个红包的平均金额必须在1.00元到200.00元之间.",
      mch_billno: "1298302201201611104565455812", mch_id: "1298302201",
      re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", result_code: "FAIL",
      return_code: "SUCCESS",
      return_msg: "每个红包的平均金额必须在1.00元到200.00元之间.",
      total_amount: "300", total_num: "4", wxappid: "wx65fd9eeccd53f1a1"}
    iex> ExWechatPay.Redpack._send_group_redpack %{re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", mch_billno: "1298302201201611104565455812", send_name: "测试", total_amount: 300, total_num: 3, wishing: "测试", client_ip: "127.0.0.1", act_name: "测试", remark: "测试", amt_type: "ALL_RAND"}
    %{err_code: "SUCCESS", err_code_des: "发放成功",
      mch_billno: "1298302201201611104565455812", mch_id: "1298302201",
      re_openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", result_code: "SUCCESS",
      return_code: "SUCCESS", return_msg: "发放成功",
      send_listid: "1000041701201611103000073626083", total_amount: "300",
      total_num: "3", wxappid: "wx65fd9eeccd53f1a1"}
    iex> ExWechatPay.Coupon._send_coupon %{coupon_stock_id: 873054, openid_count: 1, openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", partner_trade_no: "1298302201201611101235478954"}
    %{appid: "wx65fd9eeccd53f1a1", coupon_id: "996576739",
      coupon_stock_id: "873054", device_info: "", failed_count: "0",
      mch_id: "1298302201", nonce_str: "WAqbvMZUZELvkrjbsV2tVVkLSGPKlAbc",
      openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g",
      partner_trade_no: "1298302201201611101235478954", resp_count: "1",
      result_code: "SUCCESS", ret_code: "SUCCESS", return_code: "SUCCESS",
      return_msg: "", sub_mch_id: "", success_count: "1"}
    iex> ExWechatPay.CompanyTransfer._create_transfer %{partner_trade_no: "1298302201201611101235485642", openid: "oq6v8wz81G3YrqONwm2OhBp_gf2g", check_name: "NO_CHECK", re_user_name: "小晖", amount: 100, desc: "测试", spbill_create_ip: "127.0.0.1"}
    %{device_info: "", mch_appid: "wx65fd9eeccd53f1a1", mchid: "1298302201",
      nonce_str: "eJfyVc+dn8YEv980bY42alXjHxXZyyk9",
      partner_trade_no: "1298302201201611101235485642",
      payment_no: "1000018301201611104826365594",
      payment_time: "2016-11-10 20:37:22", result_code: "SUCCESS",
      return_code: "SUCCESS", return_msg: ""}
    ```
