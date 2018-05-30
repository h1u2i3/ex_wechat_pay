defmodule ExWechatPay.Utils.Signature do
  use ExWechatPay.Base

  @spec add_sign(map) :: map
  def add_sign(post_map) do
    post_map
    |> joined_string
    |> add_appkey
    |> sign_hash
    |> add_sign_to_map(post_map, :sign)
  end

  def jsapi_sign(map) do
    map
    |> joined_string
    |> add_appkey
    |> sign_hash
    |> add_sign_to_map(map, :paySign)
  end

  defp joined_string(post_map) do
    post_map
    |> Enum.sort
    |> Enum.map(&generate_string/1)
    |> Enum.join("&")
  end

  defp generate_string({key, value}) do
    "#{Atom.to_string key}=#{value}"
  end

  defp add_appkey(string) do
    case _sandbox() do
      true   ->  string <> "&key=ABCDEFGHIJKLMNOPQRSTUVWXYZ123456"
      false  ->  string <> "&key=#{_appkey()}"
    end
  end

  defp sign_hash(string) do
    :crypto.hash(:md5, string) |> Base.encode16
  end

  defp add_sign_to_map(hash, map, key) do
    map |> Map.put(key, hash)
  end
end
