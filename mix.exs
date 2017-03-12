defmodule Dashclock.Mixfile do
  use Mix.Project

  def project do
    [app: :dashclock,
     version: "0.1.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Dashclock, []},
     applications: [
       :phoenix,
       :phoenix_pubsub,
       :phoenix_html,
       :cowboy,
       :exrm,
       :logger,
       :ja_serializer,
       :gettext,
       :httpotion,
       :certifi,
       :timex,
       :hackney,
     ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:exrm, "~> 1.0"},
     {:httpotion, "~> 3.0.0"},
     {:ja_serializer, "~> 0.9.0"},
     {:timex, "~> 2.2"},
     {:certifi, "~> 0.4.0"},
     {:hackney, "~> 1.6"},
    ]
  end
end
