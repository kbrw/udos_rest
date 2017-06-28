defmodule Api.User do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/:id" do
    value = KV.get(id)
    send_resp(conn, 200, value)
  end
end