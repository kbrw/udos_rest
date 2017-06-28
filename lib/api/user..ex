defmodule Api.User do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/:id" do
    conn = put_resp_content_type(conn, "application/json")
    case KV.get(id) do
      nil   -> send_resp(conn, 404, "")
      value -> send_resp(conn, 200, Poison.encode!(value))
    end
  end

  post "/" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    Logger.debug(inspect(body))
    send_resp(conn, 204, "")
  end
end