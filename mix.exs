defmodule Rummage.Phoenix.Mixfile do
  use Mix.Project

  @version "1.2.0"
  @url "https://github.com/aditya7iyengar/rummage_phoenix"

  def project do
    [
      app: :rummage_phoenix,
      version: @version,
      elixir: "~> 1.10",
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,

      # Test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "Rumamge.Phoenix",
      docs: docs()
    ]
  end

  def application do
    [
      applications: [
        :logger,
        :phoenix_html,
        :phoenix,
        :rummage_ecto
      ]
    ]
  end

  def package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Adi Iyengar"],
      licenses: ["MIT"],
      links: %{"Github" => @url}
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.4.0 or ~> 1.5.0"},
      {:phoenix_html, "~> 2.14"},
      {:rummage_ecto, git: "https://github.com/annkissam/rummage_ecto.git", tag: "2.0.0-rc.1"},
      {:jason, "~> 1.2", only: [:dev, :test]},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:excoveralls, "~> 0.3", only: :test},
      {:inch_ex, "~> 0.5", only: [:dev, :test, :docs]},
      {:postgrex, ">= 0.0.0", only: [:test]}
    ]
  end

  defp description do
    """
    A full support library for phoenix that allows us to search, sort and
    paginate phoenix ecto models.
    """
  end

  def docs do
    [
      main: "Rummage.Phoenix",
      source_url: @url,
      extras: ["doc_readme.md", "CHANGELOG.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate"
      ],
      "ecto.reset": [
        "ecto.drop",
        "ecto.setup"
      ],
      test: [
        # "ecto.drop",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "priv", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
