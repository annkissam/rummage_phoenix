defmodule Rummage.Phoenix.Mixfile do
  use Mix.Project

  @version "2.1.0"
  @url "https://github.com/annkissam/rummage_phoenix"

  def project do
    [
      app: :rummage_phoenix,
      version: @version,
      elixir: "~> 1.13",
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
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.2"},
      # TODO: use annkissam github after merge forks
      # {:rummage_ecto, github: "annkissam/rummage_ecto"},
      {:rummage_ecto, github: "iv-3an-ev/rummage_ecto"},
      {:credo, "~> 1.6", only: [:dev, :test]},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14", only: :test},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test, :docs], runtime: false},
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
      ],
      publish: ["hex.publish", &git_tag/1]
    ]
  end

  defp git_tag(_args) do
    System.cmd("git", ["tag", Mix.Project.config()[:version]])
    System.cmd("git", ["push", "--tags"])
  end

  defp elixirc_paths(:test), do: ["lib", "priv", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
