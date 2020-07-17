defmodule BearingsWeb.DailiesEditPage do
  @moduledoc """
  Module to interact with dailies add/edit pages
  """

  use Hound.Helpers

  alias BearingsWeb.Router.Helpers, as: Routes

  alias Bearings.Dailies.{Daily, Goal}
  alias BearingsWeb.DailiesLive.{Edit, New}
  alias BearingsWeb.Endpoint

  def visit_add_page(user) do
    navigate_to(Routes.live_path(Endpoint, New, user))
  end

  def visit_edit_page(user, daily) do
    navigate_to(Routes.live_path(Endpoint, Edit, user, daily))
  end

  def complete_goal(%Goal{} = goal) do
    click({:css, "[data-test='goal_completed'][data-test-id='#{goal.id}']"})
  end

  def daily_plan do
    visible_text({:css, "[data-test='daily_plan']"})
  end

  def fill_form(%Daily{} = daily) do
    value = Timex.format!(daily.date, "%Y-%m-%d", :strftime)
    execute_script("document.querySelector('[data-test=\"date\"]').value = '#{value}'")
    fill_field({:css, "[data-test='personal_journal']"}, daily.personal_journal.raw)
    fill_field({:css, "[data-test='daily_plan']"}, daily.daily_plan.raw)
  end

  def personal_journal do
    visible_text({:css, "[data-test='personal_journal']"})
  end

  def save do
    click({:css, "[data-test='save_daily']"})
  end

  # defp fill_goal(%Goal{} = goal) do
  #   fill_field({:css, "[data-test='goal_body'][data-test-id='#{goal.id}']"}, goal.body)
  # end
end
