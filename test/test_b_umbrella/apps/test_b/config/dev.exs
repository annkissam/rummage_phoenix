use Mix.Config

# Configure your database
config :test_b, TestB.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "test_b_dev",
  hostname: "localhost",
  pool_size: 10
