defmodule ExWechatPay.Base do
  defmacro __using__(_opts) do
    for {key, value} <- Application.get_env(:ex_wechat_pay, ExWechatPay) do
      quote do
        defp unquote(method_name(key))() do
          unquote(value)
        end
      end
    end
  end

  defp method_name(key) do
    "_" <> Atom.to_string(key)
    |> String.to_atom
  end
end
