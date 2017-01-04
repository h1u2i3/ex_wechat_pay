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
  defp parse_data([ "//" <> _    | tail ], result, temp) do
    parse_data(tail, result, temp)
  end
  defp parse_data([ "# " <> rest | tail ], result, temp) do
    parse_data(tail, result, temp |> parse_doc(rest))
  end
  defp parse_data([ "name:" <> rest | tail ], result, temp) do
    parse_data(tail, result, temp |> Map.put(:name, String.to_atom("_" <> String.trim(rest))))
  end
  defp parse_data([ "path:" <> rest | tail ], result, temp) do
    parse_data(tail, result, temp |> Map.put(:path, rest |> String.trim))
  end
  defp parse_data([ "cert:" <> rest | tail ], result, temp) do
    parse_data(tail, result, temp |> Map.put(:cert, rest |> parse_atom))
  end
  defp parse_data([ "required:" <> rest | tail ], result, temp) do
    parse_data(tail, result, temp |> Map.put(:required, rest |> parse_keys))
  end
  defp parse_data([ "optional:" | tail ], result, temp) do
    parse_data(tail, result ++ [temp |> Map.put(:optional, []) |> check_doc])
  end
  defp parse_data([ "optional:" <> rest | tail ], result, temp) do
    parse_data(tail, result ++ [temp |> Map.put(:optional, rest |> parse_keys) |> check_doc])
  end

  defp check_doc(temp) do
    case Map.get(temp, :doc) do
      nil   -> Map.put(temp, :doc, false)
      _     -> temp
    end
  end

  defp parse_doc(temp, doc) do
    case Map.get(temp, :doc) do
      nil       -> Map.put(temp, :doc, doc |> String.trim)
      current   -> Map.put(temp, :doc, current <> "\n" <> String.trim(doc))
    end
  end

  defp parse_atom(string) do
    string
    |> String.trim
    |> String.to_atom
  end

  defp parse_keys(string) do
    string
    |> String.trim
    |> String.split(", ")
    |> Enum.map(&String.to_atom/1)
  end
end
