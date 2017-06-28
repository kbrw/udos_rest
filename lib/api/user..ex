defmodule Api.User do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/:id" do
    send_resp(conn, 200, id)
  end
end