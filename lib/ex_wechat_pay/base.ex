defmodule ExWechatPay.Base do
  @empty [
    appid: nil,
    mch_id: nil,
    cert: nil,
    cert_key: nil,
    appkey: nil,
    sandbox: nil
  ]

  defmacro __using__(_opts) do
    configs =
      Application.get_env(:ex_wechat_pay, ExWechatPay) || @empty
    for {key, value} <- configs do
      quote do
        defp unquote(method_name(key))() do
          unquote(value)
        end
      end
    end
  end

  defp method_name(key) do
    "_#{key}"
    |> String.to_atom
  end
end
