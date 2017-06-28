defmodule Api.Plug.Json do
  require Logger
  import Plug.Conn

  def init(opts), do: opts
  def call(conn,_opts) do
    {:ok, json, conn} = read_body(conn)

    case Poison.decode(json) do
      {:ok,json_obj} -> put_private(conn, :json_obj, json_obj)
      _ ->
        resp_body = Poison.encode!(%{message: "Invalid JSON"})
        send_resp(conn, 400, resp_body) |> halt
    end
  end
end