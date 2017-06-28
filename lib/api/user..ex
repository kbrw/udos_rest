defmodule Api.User do
  use Plug.Router

  plug Api.Plug.Json
  plug :match
  plug :dispatch

  get "/:id" do
    case KV.get(id) do
      nil   -> send_resp(conn, 404, "")
      value -> send_resp(conn, 200, Poison.encode!(value))
    end
  end

  post "/" do
    case conn.private[:json_obj] do
      %{"firstname" => firstname, "lastname" => lastname}=user->
        id = :crypto.hash(:sha, "#{firstname}#{lastname}") |> Base.encode16 |> String.slice(0,6)
        KV.put(id, user)
        conn
          |> put_resp_header("location", id)
          |> send_resp(201, "")
      _ -> send_resp(conn, 400, Poison.encode!(%{message: "Invalid payload"}))
    end
  end

  put "/:id" do
    user = conn.private[:json_obj]

    KV.put(id, user)

    send_resp(conn, 204, "")
  end

  delete "/:id" do
    KV.delete(id)

    send_resp(conn, 204, "")
  end
end