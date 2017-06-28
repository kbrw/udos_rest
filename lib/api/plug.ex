defmodule Api.Plug.Json do
  require Logger
  import Plug.Conn

  def init(opts), do: opts
  def call(conn,_opts) do
    {:ok, json, conn} = read_body(conn)
    # Logger.debug("#{conn.method} --> JSON"<> inspect(json))
    conn = conn |> put_resp_content_type("application/json")
    case {conn.method,Poison.decode(json)} do
      { method, _} when not method in ~w(POST PUT) -> conn
      {_method, {:ok, body}} -> put_private(conn, :json_obj, body)
      _ ->
        resp_body = Poison.encode!(%{message: "Invalid JSON"})
        send_resp(conn, 400, resp_body) |> halt
    end
  end
end