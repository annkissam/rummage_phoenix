defmodule Rummage.Phoenix.Mixfile do
  use Mix.Project

  @version "0.6.0"
  @url "https://github.com/Excipients/rummage_phoenix"

  def project do
    [
      app: :rummage_phoenix,
      version: @version,
      elixir: "~> 1.3",
      deps: deps(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "Rumamge.Phoenix",
      docs: docs(),
    ]
  end

  def application do
    [
      applications: [
        :logger,
      ],
    ]
  end

  def package do
  [
    name: :rummage_phoenix,
    files: ["lib", "mix.exs"],
    maintainers: ["Adi Iyengar"],
    licenses: ["MIT"],
    links: %{"Github" => @url},
  ]
end

  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:rummage_ecto, path: "/Users/adiiyengar/Excipients/rummage_ecto"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
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
      source_url: "https://github.com/Excipients/rummage_phoenix",
      extras: ["doc_readme.md"],
      source_ref: "v#{@version}"
    ]
  end
end
