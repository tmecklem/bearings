defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.DailiesEditPage
  alias BearingsWeb.DailiesShowPage
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page

  setup %{auth_server: auth_server} do
    user = insert(:user)
    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(user)

    {:ok, user: user}
  end

  test "planning a day", %{user: user} do
    daily = build(:daily)

    DailiesEditPage.visit_add_page(user)
    DailiesEditPage.fill_form(daily)
    DailiesEditPage.save()
    assert Page.flash_info()
  end

  test "marking previous day's goal as completed on create", %{user: user} do
    daily = build(:daily)
    previous_daily = insert(:daily, owner_id: user.id, date: Timex.shift(daily.date, days: -1))
    goal = %{insert(:goal, daily: previous_daily) | completed: true}

    DailiesEditPage.visit_add_page(user)
    DailiesEditPage.complete_goal(goal)
    DailiesEditPage.fill_form(daily)
    DailiesEditPage.save()
    assert Page.flash_info()
    assert DailiesShowPage.goal_body(goal) == goal.body
    assert DailiesShowPage.goal_completed(goal)
  end

  test "editing a day's plan", %{user: user} do
    daily = insert(:daily, owner_id: user.id)

    DailiesEditPage.visit_edit_page(user, daily)
    DailiesEditPage.fill_form(daily)
    DailiesEditPage.save()
    assert Page.flash_info()
  end

  test "marking previous day's goal as completed on edit", %{user: user} do
    daily = insert(:daily, owner_id: user.id)
    previous_daily = insert(:daily, owner_id: user.id, date: Timex.shift(daily.date, days: -1))
    goal = %{insert(:goal, daily: previous_daily) | completed: true}

    DailiesEditPage.visit_edit_page(user, daily)
    DailiesEditPage.complete_goal(goal)
    DailiesEditPage.save()
    assert Page.flash_info()
    assert DailiesShowPage.goal_body(goal) == goal.body
    assert DailiesShowPage.goal_completed(goal)
  end

  test "marking a goal as completed", %{user: user} do
    daily = insert(:daily, owner_id: user.id)
    goal = %{insert(:goal, daily: daily) | completed: true}

    DailiesEditPage.visit_edit_page(user, daily)
    DailiesEditPage.complete_goal(goal)
    DailiesEditPage.save()
    assert Page.flash_info()
    assert DailiesShowPage.goal_body(goal) == goal.body
    assert DailiesShowPage.goal_completed(goal)
  end
end
