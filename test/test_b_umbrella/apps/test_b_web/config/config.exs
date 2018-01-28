# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :test_b_web,
  namespace: TestBWeb,
  ecto_repos: [TestB.Repo]

# Configures the endpoint
config :test_b_web, TestBWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bEqEgQbw1xnbilh23zrPgU/8Y6Vl/H0K88B4duZEcvOKmad5HU49fiFSMgf5QAVZ",
  render_errors: [view: TestBWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestBWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :test_b_web, :generators,
  context_app: :test_b

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
