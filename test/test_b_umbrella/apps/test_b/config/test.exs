use Mix.Config

# Configure your database
config :test_b, TestB.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "test_b_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
