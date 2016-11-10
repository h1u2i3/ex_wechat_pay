defmodule ExWechatPay.Utils.NonceStr do

  @spec generate_nonce_str(map) :: map
  def generate_nonce_str(post_map) when is_map(post_map) do
    post_map
    |> Map.put(:nonce_str, :crypto.strong_rand_bytes(32) |> Base.encode64 |> binary_part(0, 32))
  end

end
