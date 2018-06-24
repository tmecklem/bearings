defmodule BearingsWeb.DailiesEditPage do
  @moduledoc """
  Module to interact with dailies add/edit pages
  """

  use Wallaby.DSL

  import BearingsWeb.Router.Helpers, only: [daily_path: 3, daily_path: 4]
  import Wallaby.Query, only: [css: 1, css: 2]

  alias Bearings.Dailies.{Daily, Goal, Markdown}
  alias BearingsWeb.Endpoint

  def visit_add_page(session, user) do
    visit(session, daily_path(Endpoint, :new, user))
  end

  def visit_edit_page(session, user, daily) do
    visit(session, daily_path(Endpoint, :edit, user, daily))
  end

  def complete_goal(session, %Goal{} = goal) do
    click(session, css("[data-test='goal_completed'][data-test-id='#{goal.id}']"))
  end

  def daily_plan(%Markdown{raw: value}) do
    css("[data-test='daily_plan']", text: value)
  end

  def fill_form(session, %Daily{} = daily) do
    session
    |> fill_in(css("[data-test='date']"), with: Timex.format!(daily.date, "%F", :strftime))
    |> fill_in(css("[data-test='personal_journal']"), with: daily.personal_journal.raw)
    |> fill_in(css("[data-test='daily_plan']"), with: daily.daily_plan.raw)
  end

  def fill_goals(session, goals) do
    Enum.reduce(goals, session, &fill_goal/2)
  end

  def personal_journal(%Markdown{raw: value}) do
    css("[data-test='personal_journal']", text: value)
  end

  def save(session) do
    click(session, css("[data-test='save_daily']"))
  end

  defp fill_goal(%Goal{} = goal, session) do
    session
    |> fill_in(css("[data-test='goal_body'][data-test-id='#{goal.id}']"), with: goal.body)
  end
end
