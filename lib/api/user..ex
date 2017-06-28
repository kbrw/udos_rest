defmodule Api.User do
  use Plug.Router

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

    case Poison.decode(body) do
      {:ok, %{"firstname" => firstname, "lastname" => lastname}=user}->
        id = :crypto.hash(:sha, "#{firstname}#{lastname}") |> Base.encode16 |> String.slice(0,6)
        KV.put(id, user)
        conn
          |> put_resp_header("location", id)
          |> send_resp(201, "")
      {:ok, _}   -> send_resp(conn, 400, Poison.encode!(%{message: "Invalid payload"}))
      {:error,_} -> send_resp(conn, 400, Poison.encode!(%{message: "Invalid JSON"}))
    end
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