defmodule BearingsWeb.TemplateEditPage do
  @moduledoc """
  Module to interact with template add/edit pages
  """

  use Wallaby.DSL

  import BearingsWeb.Router.Helpers, only: [template_path: 2]
  import Wallaby.Query, only: [css: 1]

  alias Bearings.Dailies.Template
  alias BearingsWeb.Endpoint

  def visit_page(session) do
    visit(session, template_path(Endpoint, :edit))
  end

  def fill_form(session, %Template{} = template) do
    fill_in(session, css("[data-test='personal_journal']"), template.personal_journal.raw)
    fill_in(session, css("[data-test='daily_plan']"), template.daily_plan.raw)
  end

  def save(session) do
    click(session, css("[data-test='save_template']"))
  end
end
