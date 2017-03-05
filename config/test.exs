use Mix.Config

config :logger, :console,
  level: :error

config :rummage_ecto, Rummage.Ecto,[
  default_repo: Rummage.Ecto.Repo,
  default_per_page: 2,
]

config :rummage_phoenix, ecto_repos: [Rummage.Phoenix.Repo]

config :rummage_phoenix, Rummage.Phoenix.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "rummage_phoenix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
