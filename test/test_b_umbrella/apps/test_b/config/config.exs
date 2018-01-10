use Mix.Config

config :test_b, ecto_repos: [TestB.Repo]

import_config "#{Mix.env}.exs"
