defmodule ExWechatPay.Utils.ApiParser do

  def api_definition(module) do
    __DIR__
    |> Path.join("../apis/#{List.last String.split(Macro.underscore(module), "/")}")
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(String.length(&1) == 0))
    |> Enum.to_list
    |> parse_data([])
  end

  defp parse_data(origin, result, temp \\ %{})
  defp parse_data([], result, _), do: result
  defp parse_data([ "//" <> _    | tail ], result, temp), do: parse_data(tail, result, temp)
  defp parse_data([ "# " <> rest | tail ], result, temp) do
    {_, temp} =  Map.get_and_update(temp, :doc, fn(current)->
                   case current do
                      nil    -> {current, String.trim(rest)}
                      _      -> {current, current <> "\n" <> String.trim(rest)}
                   end
                 end)
    parse_data(tail, result, temp)
  end
  defp parse_data([ "name: " <> rest | tail ], result, temp) do
    temp = temp |> Map.put(:name, String.to_atom("_" <> String.trim(rest)))
    parse_data(tail, result, temp)
  end
  defp parse_data([ "path: " <> rest | tail ], result, temp) do
    temp = temp |> Map.put(:path, rest |> String.trim |> String.replace("/", "_"))
    parse_data(tail, result, temp)
  end
  defp parse_data([ "cert: " <> rest | tail ], result, temp) do
    temp = temp |> Map.put(:cert, rest |> String.trim |> String.to_atom)
    parse_data(tail, result, temp)
  end
  defp parse_data([ "required: " <> rest | tail ], result, temp) do
    temp = temp |> Map.put(:required, rest |> String.trim |> String.split(",") |> Enum.map(&String.trim/1))
    parse_data(tail, result, temp)
  end
  defp parse_data([ "optional: " <> rest | tail ], result, temp) do
    temp = temp |> Map.put(:optional, rest |> String.trim |> String.split(",") |> Enum.map(&String.trim/1))
    temp = case Map.get(temp, :doc) do
      nil   -> Map.put(temp, :doc, "no doc")
      _     -> temp
    end
    parse_data(tail, result ++ [temp])
  end
end
