defmodule ExWechatPay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_wechat_pay,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, github: "elixir-lang/ex_doc", only: :dev},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:plug, "~> 1.7"},
      {:floki, "~> 0.20.4"}
    ]
  end
end
