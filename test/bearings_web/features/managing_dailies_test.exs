defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.EditDailiesPage
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page

  setup %{auth_server: auth_server, session: session} do
    user = insert(:user)
    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(session, user)

    :ok
  end

  test "planning a day", %{session: session} do
    daily = build(:daily)

    session
    |> EditDailiesPage.visit_add_page()
    |> EditDailiesPage.fill_form(daily)
    |> EditDailiesPage.save()
    |> assert_has(Page.flash_info())
  end

  test "editing a day's plan", %{session: session} do
    daily = insert(:daily)

    session
    |> EditDailiesPage.visit_edit_page(daily)
    |> EditDailiesPage.fill_form(daily)
    |> EditDailiesPage.save()
    |> assert_has(Page.flash_info())
  end
end
