defmodule ExWechatPay.Utils.Method do
  use ExWechatPay.Base

  def define_method(method_data) do
    %{doc: doc, path: path, name: name, cert: cert,
      required: required, optional: optional} = method_data
    quote do
      @doc false
      def required_fields(path) do
        unquote(Enum.map(required, &String.to_atom/1))
      end

      @doc false
      def all_fields(path) do
        unquote(Enum.map(required ++ optional, &String.to_atom/1))
      end

      @doc false
      def ssl_post(path, body) do
        case post(path, body, [], ssl: [certfile: unquote(_cert)]) do
          {:ok, response} -> response.body
          {:error, error} ->
            case error.reason do
              :close  ->  post(path, body, [], ssl: [certfile: unquote(_cert)])
              _       ->  %{error: error.reason}
            end
        end
      end

      @doc false
      def normal_post(path, body) do
        case post(path, body) do
          {:ok, response} -> response.body
          {:error, error} ->
            case error.reason do
              :close  ->  post(path, body)
              _       ->  %{error: error.reason}
            end
        end
      end

      @doc """
        #{unquote(doc)}
      """
      def unquote(name)(post_map) do
        case render(unquote(path), post_map) do
          {:ok, body} ->
            case unquote(cert) do
              :true -> ssl_post(unquote(path |> String.replace("_", "/")), body)
              :false -> normal_post(unquote(path |> String.replace("_", "/")), body)
            end
          {:error, reason} -> {:error, reason}
        end
      end
    end
  end
end
