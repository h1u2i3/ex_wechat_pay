defmodule ExWechatPay.Utils.XmlRender do

  @spec render_xml(map) :: String.t
  def render_xml(map) when is_map(map) do
    map
    |> Enum.map(&render_item/1)
    |> Enum.join
    |> wrap_xml
  end

  defp render_item(item)
  defp render_item({key, value}) when is_map(value), do: "<#{key}><![CDATA[#{Poison.encode! value}]]</#{key}>"
  defp render_item({key, value}), do: "<#{key}>#{value}</#{key}>"

  defp wrap_xml(xml_body), do: "<xml>#{xml_body}</xml>"
end
