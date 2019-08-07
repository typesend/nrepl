defmodule NRepl.MixProject do
  use Mix.Project

  def project do
    [
      app: :nrepl,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: "An Elixir nREPL client.",
      deps: deps(),
      source_url: url,
      homepage_url: url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NRepl.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bento, "~> 0.9.2"}
    ]
  end

  defp package do
    [
      name: "nrepl",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => url},
    ]
  end

  defp url do
    "https://github.com/typesend/nrepl"
  end
end
