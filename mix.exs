defmodule Rummage.Phoenix.Mixfile do
  use Mix.Project

  @version "0.1.0"
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
      {:rummage_ecto, [git: "https://github.com/Excipients/rummage_ecto", optional: true]},
      {:ex_doc, ">= 0.0.0", only: :dev},
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
      source_url: "https://github.com/Excipients/rummage_phoenix",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end
