defmodule BearingsWeb.DailiesEditPage do
  @moduledoc """
  Module to interact with dailies add/edit pages
  """

  use Wallaby.DSL

  import BearingsWeb.Router.Helpers, only: [daily_path: 3, daily_path: 4]
  import Wallaby.Query, only: [css: 1]

  alias Bearings.Dailies.Daily
  alias BearingsWeb.Endpoint

  def visit_add_page(session, user) do
    visit(session, daily_path(Endpoint, :new, user))
  end

  def visit_edit_page(session, user, daily) do
    visit(session, daily_path(Endpoint, :edit, user, daily))
  end

  def fill_form(session, %Daily{} = daily) do
    session
    |> fill_in(css("[data-test='date']"), with: Timex.format!(daily.date, "%F", :strftime))
    |> fill_in(css("[data-test='personal_journal']"), with: daily.personal_journal.raw)
    |> fill_in(css("[data-test='daily_plan']"), with: daily.daily_plan.raw)
  end

  def save(session) do
    click(session, css("[data-test='save_daily']"))
  end
end
