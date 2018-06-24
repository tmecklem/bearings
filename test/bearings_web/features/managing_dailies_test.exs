defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.DailiesEditPage
  alias BearingsWeb.DailiesShowPage
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

  test "marking previous day's goal as completed on create", %{session: session, user: user} do
    daily = build(:daily)
    previous_daily = insert(:daily, owner_id: user.id, date: Timex.shift(daily.date, days: -1))
    goal = %{insert(:goal, daily: previous_daily) | completed: true}

    session
    |> DailiesEditPage.visit_add_page(user)
    |> DailiesEditPage.complete_goal(goal)
    |> DailiesEditPage.fill_form(daily)
    |> DailiesEditPage.save()
    |> assert_has(Page.flash_info())
    |> assert_has(DailiesShowPage.goal_body(goal))
    |> assert_has(DailiesShowPage.goal_completed(goal))
  end

  test "editing a day's plan", %{session: session, user: user} do
    daily = insert(:daily, owner_id: user.id)

    session
    |> DailiesEditPage.visit_edit_page(user, daily)
    |> DailiesEditPage.fill_form(daily)
    |> DailiesEditPage.save()
    |> assert_has(Page.flash_info())
  end

  test "marking previous day's goal as completed on edit", %{session: session, user: user} do
    daily = insert(:daily, owner_id: user.id)
    previous_daily = insert(:daily, owner_id: user.id, date: Timex.shift(daily.date, days: -1))
    goal = %{insert(:goal, daily: previous_daily) | completed: true}

    session
    |> DailiesEditPage.visit_edit_page(user, daily)
    |> DailiesEditPage.complete_goal(goal)
    |> DailiesEditPage.save()
    |> assert_has(Page.flash_info())
    |> assert_has(DailiesShowPage.goal_body(goal))
    |> assert_has(DailiesShowPage.goal_completed(goal))
  end

  test "marking a goal as completed", %{session: session, user: user} do
    daily = insert(:daily, owner_id: user.id)
    goal = %{insert(:goal, daily: daily) | completed: true}

    session
    |> DailiesEditPage.visit_edit_page(user, daily)
    |> DailiesEditPage.complete_goal(goal)
    |> DailiesEditPage.save()
    |> assert_has(Page.flash_info())
    |> assert_has(DailiesShowPage.goal_body(goal))
    |> assert_has(DailiesShowPage.goal_completed(goal))
  end
end
