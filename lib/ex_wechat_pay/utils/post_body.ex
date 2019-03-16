defmodule ExWechatPay.Utils.PostBody do
  use ExWechatPay.Base

  import ExWechatPay.Utils.NonceStr
  import ExWechatPay.Utils.Signature
  import ExWechatPay.Utils.XmlRender

  alias __MODULE__

  defstruct valid?: true, reason: nil, map: %{}, required: [], miss: []

  def cast(map, keys) do
    __MODULE__
    |> struct(map: map |> Map.take(keys))
  end

  def required(body, keys) do
    body
    |> struct(required: keys)
  end

  def add_config_data(body) do
    body
    |> add_item({:appid, _appid()})
    |> add_item({:mch_id, _mch_id()})
    |> add_item({:op_user_id, _mch_id()})
    |> add_item({:wxappid, _appid()})
    |> add_item({:mch_appid, _appid()})
    |> add_item({:mchid, _mch_id()})
  end

  def add_nonce_str(body) do
    body
    |> struct(map: body.map |> generate_nonce_str)
  end

  def generate_miss_keys(body) do
    body
    |> struct(miss: body.required -- (Map.keys(body.map) ++ [:sign]))
  end

  def validate_body(body)
  def validate_body(%PostBody{valid?: false} = body), do: body

  def validate_body(%PostBody{valid?: true, map: %{transaction_id: _}} = body) do
    body
    |> remove_need([:out_trade_no, :refund_id])
  end

  def validate_body(%PostBody{valid?: true, map: %{out_trade_no: _}} = body) do
    body
    |> remove_need([:transaction_id, :refund_id])
  end

  # def validate_body(%PostBody{valid?: true,
  #                             map: %{out_refund_no: _}} = body) do
  #   body
  #   |> remove_need([:refund_id, :out_trade_no, :transaction_id])
  # end

  # def validate_body(%PostBody{valid?: true,
  #                             map: %{refund_id: _}} = body) do
  #   body |> remove_need([:out_refund_no, :out_trade_no, :transaction_id])
  # end

  def validate_body(%PostBody{valid?: true} = body), do: body

  def validate_presence(body)
  def validate_presence(%PostBody{valid?: true, miss: []} = body), do: body

  def validate_presence(%PostBody{valid?: true, miss: _} = body) do
    body
    |> add_error(key_miss_message(body.miss))
  end

  def validate_presence(%PostBody{} = body), do: body

  def validate_jsapi(body)

  def validate_jsapi(%PostBody{valid?: true, map: %{trade_type: "JSAPI"}} = body) do
    body |> add_required(:openid)
  end

  def validate_jsapi(%PostBody{valid?: true} = body), do: body
  def validate_jsapi(%PostBody{valid?: false} = body), do: body

  def sign(body)

  def sign(%PostBody{valid?: true} = body) do
    body |> struct(map: body.map |> add_sign)
  end

  def sign(%PostBody{valid?: false} = body), do: body

  def render_body(body)

  def render_body(%PostBody{valid?: true} = body) do
    {:ok, body.map |> render_xml}
  end

  def render_body(%PostBody{valid?: false} = body) do
    {:error, body.reason}
  end

  defp add_item(body, {key, value}) do
    if item?(body, key) do
      body |> struct(map: body.map |> Map.put(key, value))
    else
      body
    end
  end

  defp item?(body, key) do
    Enum.member?(body.required, key) && !Enum.member?(body.map, key)
  end

  defp add_required(body, key) do
    body |> struct(required: body.required ++ [key])
  end

  defp add_error(body, reason) do
    body |> struct(valid?: false, reason: reason)
  end

  defp remove_item(body, keys) do
    body |> struct(map: body.map |> Map.drop(keys))
  end

  defp remove_required(body, keys) do
    body |> struct(required: body.required -- keys)
  end

  defp key_miss_message(keys) do
    "Missed post body required keys: #{Enum.join(keys, " ")}"
  end

  defp remove_need(body, keys) do
    body |> remove_item(keys) |> remove_required(keys)
  end
end
