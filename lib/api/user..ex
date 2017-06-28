defmodule Api.User do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/:id" do
    case KV.get(id) do
      nil   -> send_resp(conn, 404, "")
      value -> send_resp(conn, 200, Poison.encode!(value))
    end
  end
end