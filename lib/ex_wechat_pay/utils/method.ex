defmodule ExWechatPay.Utils.Method do
  use ExWechatPay.Base

  @doc """
    Define methods base on the api definition data.
  """
  def define_methods(method_map) do
    do_define_methods(method_map, [], [], [])
  end

  defp do_define_methods(method_map, required_methods, all_fields_methods, request_methods)

  defp do_define_methods([], required_methods, all_fields_methods, request_methods) do
    all_fields_methods = all_fields_methods ++ [quote(do: def(all_fields(_), do: []))]

    required_methods = required_methods ++ [quote(do: def(required_methods(_), do: []))]

    methods =
      quote do
        defp do_request(path, body, cert \\ false)

        defp do_request(path, body, true) do
          IO.inspect(body)

          post(path, body, [],
            ssl: [
              certfile: unquote(_cert()),
              keyfile: unquote(_cert_key()),
              versions: [:"tlsv1.2"]
            ]
          )
          |> parse_response(path, body, true)
        end

        defp do_request(path, body, false) do
          post(path, body)
          |> parse_response(path, body, false)
        end

        defp parse_response(response, path, body, cert)

        defp parse_response({:ok, response}, _path, _body, _cert) do
          response.body
        end

        defp parse_response({:error, %HTTPoison.Error{reason: :close}}, path, body, cert) do
          do_request(path, body, cert)
        end

        defp parse_response({:error, error}, _, _, _) do
          %{error: error.reason}
        end
      end

    required_methods ++
      all_fields_methods ++
      request_methods ++ [methods]
  end

  defp do_define_methods(method_map, [], [], []) do
    required_method = quote do: def(required_fields(path))
    all_fields_method = quote do: def(all_fields(path))
    do_define_methods(method_map, [required_method], [all_fields_method], [])
  end

  defp do_define_methods([item | tail], required_methods, all_fields_methods, request_methods) do
    %{doc: doc, path: path, name: name, cert: cert, required: required, optional: optional} = item

    required_method = define_required_method(path, required)

    all_fields_method = define_all_fields_method(path, required, optional)

    request_method = define_request_method(doc, name, path, cert)

    do_define_methods(
      tail,
      required_methods ++ [required_method],
      all_fields_methods ++ [all_fields_method],
      request_methods ++ [request_method]
    )
  end

  defp define_request_method(doc, name, path, cert) do
    quote do
      @doc unquote(doc)
      def unquote(name)(post_map) do
        case render(unquote(path), post_map) do
          {:ok, body} ->
            do_request(unquote(path), body, unquote(cert))

          {:error, reason} ->
            {:error, reason}
        end
      end
    end
  end

  defp define_required_method(path, required) do
    quote do
      def required_fields(unquote(path) = path) do
        unquote(required)
      end
    end
  end

  defp define_all_fields_method(path, required, optional) do
    quote do
      def all_fields(unquote(path) = path) do
        unquote(required ++ optional)
      end
    end
  end
end
