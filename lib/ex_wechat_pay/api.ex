defmodule ExWechatPay.Api do
  @moduledoc """
    Generate the right post body for api use.
    Base on module name and the body definition file.
  """
  use ExWechatPay.Base

  import ExWechatPay.Utils.ApiParser
  import ExWechatPay.Utils.Method

  defmacro __using__(_opts) do
    quote do
      use HTTPoison.Base
      use ExWechatPay.Base

      import ExWechatPay.Utils.XmlParser
      import ExWechatPay.Utils.PostBody

      @before_compile unquote(__MODULE__)

      def render(path, post_map) do
        post_map
        |> cast(all_fields(path))
        |> required(required_fields(path))
        |> add_config_data
        |> add_nonce_str
        |> validate(path)
        |> sign
        |> render_body
      end

      defp validate(body, _path) do
        body
        |> validate_transaction_id
        |> validate_jsapi
        |> generate_miss_keys
        |> validate_presence
      end

      defp process_url(url) do
        case _sandbox do
          false ->  "https://api.mch.weixin.qq.com" <> url
          true  ->  "https://api.mch.weixin.qq.com/sandbox" <> url
        end
      end

      defp process_response_body(body) do
        parse_xml(body)
      end

      defoverridable [validate: 2]
    end
  end

  defmacro __before_compile__(env) do
    env.module
    |> api_definition
    |> compile
  end

  @doc false
  def compile(origin) do
    ast_data = for item <- origin do
                 define_method(item)
               end

    quote do
      unquote(ast_data)
    end
  end
end