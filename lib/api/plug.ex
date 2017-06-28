defmodule Api.Plug.Json do
  require Logger

  def init(opts), do: opts
  def call(conn,_opts) do
    Logger.debug("Here in Api.Plug.Json")
    conn
  end
end