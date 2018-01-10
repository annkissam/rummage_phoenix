use Mix.Config

config :logger, :console,
  level: :error

config :rummage_ecto, Rummage.Ecto, [
  default_repo: Rummage.Phoenix.Repo,
  default_per_page: 2,
]

config :rummage_phoenix, Rummage.Phoenix, [
  default_helpers: Rummage.Phoenix.Router.Helpers,
  default_per_page: 2,
]

config :rummage_phoenix, ecto_repos: [Rummage.Phoenix.Repo]

config :rummage_phoenix, Rummage.Phoenix.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: "rummage_phoenix_test",
  pool: Ecto.Adapters.SQL.Sandbox
