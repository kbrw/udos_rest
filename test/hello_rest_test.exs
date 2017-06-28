defmodule HelloRestTest do
  use ExUnit.Case, async: false # false, because same store
  use Plug.Test
  @user_id "EAFC53"
  @user_json """
    {
      "firstname": "antoine",
      "lastname": "REYT"
    }
  """

  @opts Api.Router.init([])

  test "returns 404 on non existing user" do
    conn = conn(:get, "/user/1")
    conn = Api.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end
end