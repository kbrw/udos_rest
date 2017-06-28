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

    user = Poison.decode!(body)
    id = :crypto.hash(:sha, "#{user["firstname"]}#{user["lastname"]}") |> Base.encode16 |> String.slice(0,6)

    KV.put(id, user)

    conn
      |> put_resp_header("location", id)
      |> send_resp(201, "")
  end

  put "/:id" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    user = Poison.decode!(body)

    KV.put(id, user)

    send_resp(conn, 204, "")
  end

  delete "/:id" do
    KV.delete(id)

    send_resp(conn, 204, "")
  end
end