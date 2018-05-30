defmodule ExWechatPay.Utils.NonceStr do

  @spec generate_nonce_str(map) :: map
  def generate_nonce_str(post_map) when is_map(post_map) do
    hash =
      23
      |> :crypto.strong_rand_bytes
      |> Base.encode64
      |> binary_part(0, 32)
      |> String.replace(~r/[=\/]/, "")
    post_map
    |> Map.put(:nonce_str, hash)
  end
end
