defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  # import Wallaby.Query, only: [css: 2]

  alias BearingsWeb.EditDailiesPage
  alias BearingsWeb.Page

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
