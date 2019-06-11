defmodule ViewingDailiesFromOtherUsersTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.DailiesIndexPage
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page

  setup %{auth_server: auth_server} do
    other_user = insert(:user)
    user = insert(:user)

    insert(:supporter, user: other_user, supporter: user)

    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(user)

    {:ok, user: user, other_user: other_user}
  end

  test "viewing a list of another user's daily plans", %{other_user: other_user} do
    insert(:daily, owner_id: other_user.id)

    DailiesIndexPage.visit_page()
    assert Enum.count(DailiesIndexPage.dailies()) == 1
  end
end
