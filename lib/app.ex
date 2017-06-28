defmodule HelloRest.App do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(KV, []),
      Plug.Adapters.Cowboy.child_spec(:http, Api.Router, [], [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: :user_sup]
    Supervisor.start_link(children, opts)
  end
end