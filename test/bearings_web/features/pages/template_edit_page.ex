defmodule BearingsWeb.TemplateEditPage do
  @moduledoc """
  Module to interact with template add/edit pages
  """

  use Hound.Helpers

  import BearingsWeb.Router.Helpers, only: [template_path: 2]

  alias Bearings.Dailies.Template
  alias BearingsWeb.Endpoint

  def visit_page do
    navigate_to(template_path(Endpoint, :edit))
  end

  def fill_form(%Template{} = template) do
    fill_field({:css, "[data-test='personal_journal']"}, template.personal_journal.raw)
    fill_field({:css, "[data-test='daily_plan']"}, template.daily_plan.raw)
  end

  def save do
    click({:css, "[data-test='save_template']"})
  end
end
