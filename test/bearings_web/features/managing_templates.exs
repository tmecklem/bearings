defmodule ManagingDailiesTest do
  use BearingsWeb.FeatureCase

  alias BearingsWeb.DailiesEditPage
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page
  alias BearingsWeb.TemplateEditPage

  setup %{auth_server: auth_server} do
    user = insert(:user)
    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(user)

    {:ok, user: user}
  end

  test "creating a template", %{user: user} do
    template = build(:template, owner: user.id)

    TemplateEditPage.visit_page()
    TemplateEditPage.fill_form(template)
    TemplateEditPage.save()
    DailiesEditPage.visit_add_page(user)
    assert DailiesEditPage.daily_plan() == template.daily_plan.raw
    assert DailiesEditPage.personal_journal() == template.personal_journal.raw
  end

  test "updating a template", %{user: user} do
    insert(:template, owner: user)
    template = build(:template)

    TemplateEditPage.visit_page()
    TemplateEditPage.fill_form(template)
    TemplateEditPage.save()
    DailiesEditPage.visit_add_page(user)
    assert DailiesEditPage.daily_plan() == template.daily_plan.raw
    assert DailiesEditPage.personal_journal() == template.personal_journal.raw
  end
end
