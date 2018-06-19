defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.DailiesEditPage
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page
  alias BearingsWeb.TemplateEditPage

  setup %{auth_server: auth_server, session: session} do
    user = insert(:user)
    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(session, user)

    {:ok, user: user}
  end

  test "creating a template", %{session: session, user: user} do
    template = build(:template, owner: user.id)

    session
    |> TemplateEditPage.visit_page()
    |> TemplateEditPage.fill_form(template)
    |> TemplateEditPage.save()
    |> DailiesEditPage.visit_add_page(user)
    |> assert_has(DailiesEditPage.daily_plan(template.daily_plan))
    |> assert_has(DailiesEditPage.personal_journal(template.personal_journal))
  end

  test "updating a template", %{session: session, user: user} do
    insert(:template, owner: user)
    template = build(:template)

    session
    |> TemplateEditPage.visit_page()
    |> TemplateEditPage.fill_form(template)
    |> TemplateEditPage.save()
    |> DailiesEditPage.visit_add_page(user)
    |> assert_has(DailiesEditPage.daily_plan(template.daily_plan))
    |> assert_has(DailiesEditPage.personal_journal(template.personal_journal))
  end
end
