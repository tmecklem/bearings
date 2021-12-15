defmodule BearingsWeb.FakeOAuthServer do
  @moduledoc """
  Fake server to simulate interaction with a third party OAuth server. In this
  case the behavior is closely matched to the parts of the GitHub OAuth flow
  since that's all that is supported so far.
  """

  alias Plug.Conn

  def open do
    Bypass.open()
  end

  def set_user_response(bypass, user) do
    Bypass.expect_once(bypass, "GET", "/authorize", fn conn ->
      conn = Conn.fetch_query_params(conn)

      conn
      |> Conn.put_resp_header("location", conn.query_params["redirect_uri"] <> "?code=asdf")
      |> Conn.send_resp(302, "text/html")
    end)

    Bypass.expect_once(bypass, "POST", "/access_token", fn conn ->
      Conn.resp(
        conn,
        200,
        ~s<{"access_token": "heyo", "scope": "user:email", "token_type": "bearer"}>
      )
    end)

    Bypass.expect_once(bypass, "GET", "/user", fn conn ->
      body =
        %{
          avatar: user.avatar,
          email: user.email,
          id: user.github_id |> Integer.parse() |> elem(0),
          login: user.username,
          name: user.name
        }
        |> Jason.encode!()

      conn
      |> Conn.put_resp_header("content-type", "application/json")
      |> Conn.resp(200, body)
    end)
  end
end
