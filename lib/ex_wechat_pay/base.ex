defmodule ExWechatPay.Base do
  defmacro __using__(_opts) do
    for name <- [:_appid, :_mch_id, :_cert, :_sandbox, :_appkey] do
      quote do
        defp unquote(name)() do
          Application.get_env(:ex_wechat_pay, ExWechatPay)[unquote(name_to_key(name))]
        end
      end
    end
  end

  defp name_to_key(name) do
    name
    |> Atom.to_string
    |> String.replace_prefix("_", "")
    |> String.to_atom
  end
end
