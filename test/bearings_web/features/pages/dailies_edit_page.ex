defmodule BearingsWeb.DailiesEditPage do
  @moduledoc """
  Module to interact with dailies add/edit pages
  """

  use Wallaby.DSL

  import Wallaby.Query, only: [css: 1, css: 2]

  alias Bearings.Dailies.{Daily, Goal, Markdown}
  alias BearingsWeb.DailiesLive.{Edit, New}
  alias BearingsWeb.Endpoint
  alias BearingsWeb.Router.Helpers, as: Routes

  def visit_add_page(session, user) do
    visit(session, Routes.live_path(Endpoint, New, user))
  end

  def visit_edit_page(session, user, daily) do
    visit(session, Routes.live_path(Endpoint, Edit, user, daily))
  end

  def complete_goal(session, %Goal{} = goal) do
    click(session, css("[data-test='goal_completed'][data-test-id='#{goal.id}']"))
  end

  def daily_plan(%Markdown{raw: value}) do
    css("[data-test='daily_plan']", text: value)
  end

  def fill_form(session, %Daily{} = daily) do
    value = Timex.format!(daily.date, "%Y-%m-%d", :strftime)

    session
    |> execute_script("document.querySelector('[data-test=\"date\"]').value = '#{value}'")
    |> fill_in(css("[data-test='personal_journal']"), with: daily.personal_journal.raw)
    |> fill_in(css("[data-test='daily_plan']"), with: daily.daily_plan.raw)
  end

  def personal_journal(%Markdown{raw: value}) do
    css("[data-test='personal_journal']", text: value)
  end

  def save(session) do
    click(session, css("[data-test='save_daily']"))
  end
end
