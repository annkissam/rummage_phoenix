defmodule Rummage.Phoenix.Repo do
  use Ecto.Repo,
    otp_app: :rummage_phoenix,
    adapter: Ecto.Adapters.Postgres
end
