defmodule TestB.Application do
  @moduledoc """
  The TestB Application Service.

  The test_b system business domain lives in this application.

  Exposes API to clients such as the `TestBWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(TestB.Repo, []),
    ], strategy: :one_for_one, name: TestB.Supervisor)
  end
end
