defmodule ExWechatPay.Utils.XmlParser do

  @spec parse_xml(String.t) :: map
  def parse_xml(xml_string) when is_binary(xml_string) do
    [{"xml", [], attrs}] = Floki.find(xml_string, "xml")
    for {key, _, [value]} <- attrs, into: %{} do
      {String.to_atom(key), value}
    end
  end
end
