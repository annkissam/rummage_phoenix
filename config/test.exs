import Config

config :logger, :console, level: :error

config :phoenix, :json_library, Jason

config :rummage_ecto, Rummage.Ecto,
  default_repo: Rummage.Phoenix.Repo,
  default_per_page: 2

config :rummage_phoenix, Rummage.Phoenix,
  default_helpers: Rummage.Phoenix.Router.Helpers,
  default_per_page: 2

config :rummage_phoenix, ecto_repos: [Rummage.Phoenix.Repo]

config :rummage_phoenix, Rummage.Phoenix.Repo,
  username: System.get_env("ECTO_PGSQL_USER"),
  password: System.get_env("ECTO_PGSQL_PASSWORD"),
  database: "rummage_phoenix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
