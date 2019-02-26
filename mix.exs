defmodule Caramelize.Mixfile do
  use Mix.Project

  def project do
    [
      app: :caramelize,
      version: "1.2.1",
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "Caramelize",
      source_url: "https://github.com/SRVentures/caramelize",
      docs: [extras: ["README.md"]]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    An Elixir library that converts maps from `snake_case` to `camelCase`.
    """
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:recase, "~> 0.4"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["James Rasmussen", "Jake Hasler"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/SRVentures/caramelize",
        "Docs" => "https://hexdocs.pm/caramelize/0.1.0/"
      }
    ]
  end
end
