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

  test "returns 204 on creating user" do
    conn = conn(:post, "/user", @user_json)
    conn = Api.Router.call(conn, @opts)

    headers = conn.resp_headers |> Enum.into(%{})
    assert conn.state == :sent
    assert conn.status == 201
    assert headers["location"] == @user_id
    assert conn.resp_body == ""
    assert KV.get(@user_id) == %{"firstname" => "antoine", "lastname" => "REYT"}
  end

  test "get an existing user" do
    conn = conn(:post, "/user", @user_json)
    Api.Router.call(conn, @opts)

    conn = conn(:get, "/user/#{@user_id}")
    conn = Api.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Poison.decode!(conn.resp_body) == Poison.decode!(@user_json)
  end

  test "update existing user" do
    # create
    conn = conn(:post, "/user", @user_json)
    Api.Router.call(conn, @opts)

    # update
    conn = conn(:put, "/user/#{@user_id}", """
      {
        "firstname": "antoine",
        "lastname": "REYT-2"
      }
    """)
    conn = Api.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 204
    assert conn.resp_body == ""

    # get
    conn = conn(:get, "/user/#{@user_id}")
    conn = Api.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    # assert conn.resp_body == @user_json
    assert Poison.decode!(conn.resp_body) == %{"firstname" => "antoine", "lastname" => "REYT-2"}
  end

  test "delete existing user" do
    # create
    conn = conn(:post, "/user", @user_json)
    Api.Router.call(conn, @opts)

    # delete
    conn = conn(:delete, "/user/#{@user_id}")
    conn = Api.Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 204
    assert conn.resp_body == ""

    # get
    conn = conn(:get, "/user/#{@user_id}")
    conn = Api.Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 404
  end
end