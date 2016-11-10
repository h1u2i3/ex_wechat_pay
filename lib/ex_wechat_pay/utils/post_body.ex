defmodule ExWechatPay.Utils.PostBody do
  use ExWechatPay.Base

  import ExWechatPay.Utils.NonceStr
  import ExWechatPay.Utils.Signature
  import ExWechatPay.Utils.XmlRender

  alias __MODULE__

  defstruct valid?: true, reason: nil,  map: %{}, required: [], miss: []

  def cast(map, keys),                   do: __MODULE__ |> struct(map: map |> Map.take(keys))
  def required(body, keys),              do: body |> struct(required: keys)
  def add_config_data(body),             do: body |> add_item({:appid, _appid}) |> add_item({:mch_id, _mch_id}) |> add_item({:op_user_id, _mch_id})
  def add_nonce_str(body),               do: body |> struct(map: body.map |> generate_nonce_str)
  def generate_miss_keys(body),          do: body |> struct(miss: body.required -- (Map.keys(body.map) ++ [:sign]))

  def validate_transaction_id(body)
  def validate_transaction_id(%{valid?: false} = body), do: body
  def validate_transaction_id(%{valid?: true, map: %{transaction_id: _}} = body), do: body |> remove_need(:out_trade_no)
  def validate_transaction_id(%{valid?: true, map: %{out_trade_no: _}} = body),   do: body |> remove_need(:transaction_id)
  def validate_transaction_id(%{valid?: true} = body), do: body

  def validate_presence(body)
  def validate_presence(%PostBody{valid?: true, miss: []} = body), do: body
  def validate_presence(%PostBody{valid?: true, miss: _ } = body), do: body |> add_error(key_miss_message(body.miss))
  def validate_presence(%PostBody{} = body), do: body

  def validate_jsapi(body)
  def validate_jsapi(%PostBody{valid?: true, map: %{trade_type: "JSAPI"}} = body), do: body |> add_required(:openid)
  def validate_jsapi(%PostBody{valid?: true } = body), do: body
  def validate_jsapi(%PostBody{valid?: false} = body), do: body

  def sign(body)
  def sign(%PostBody{valid?: true } = body), do: body |> struct(map: body.map |> add_sign)
  def sign(%PostBody{valid?: false} = body), do: body

  def render_body(body)
  def render_body(%PostBody{valid?: true } = body), do: {:ok,    body.map |> render_xml}
  def render_body(%PostBody{valid?: false} = body), do: {:error, body.reason}

  defp add_item(body, {key, value}),      do: if item?(body, key), do: body |> struct(map: body.map |> Map.put(key, value)), else: body
  defp item?(body, key),                  do: Enum.member?(body.required, key) && !Enum.member?(body.map, key)
  defp add_required(body, key),           do: body |> struct(required: body.required ++ [key])
  defp add_error(body, reason),           do: body |> struct(valid?: false, reason: reason)
  defp remove_item(body, key),            do: body |> struct(map: body.map |> Map.delete(key))
  defp remove_required(body, key),        do: body |> struct(required: body.required -- [key])
  defp key_miss_message(keys),            do: "still need post body keys: #{Enum.join(keys, " ")}"
  defp remove_need(body, key),            do: body |> remove_item(key) |> remove_required(key)
end
