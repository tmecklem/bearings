defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.DailiesEditPage
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page

  setup %{auth_server: auth_server, session: session} do
    user = insert(:user)
    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(session, user)

    {:ok, user: user}
  end

  test "planning a day", %{session: session, user: user} do
    daily = build(:daily)

    session
    |> DailiesEditPage.visit_add_page(user)
    |> DailiesEditPage.fill_form(daily)
    |> DailiesEditPage.save()
    |> assert_has(Page.flash_info())
  end

  test "editing a day's plan", %{session: session, user: user} do
    daily = insert(:daily)

    session
    |> DailiesEditPage.visit_edit_page(user, daily)
    |> DailiesEditPage.fill_form(daily)
    |> DailiesEditPage.save()
    |> assert_has(Page.flash_info())
  end
end
