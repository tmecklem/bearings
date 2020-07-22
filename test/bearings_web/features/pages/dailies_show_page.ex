defmodule BearingsWeb.DailiesShowPage do
  @moduledoc """
  Module to interact with dailies show pages
  """

  use Wallaby.DSL

  import Wallaby.Query, only: [css: 1, css: 2]

  alias BearingsWeb.Endpoint
  alias BearingsWeb.Router.Helpers, as: Routes

  def visit_page(session, owner, daily) do
    visit(
      session,
      Routes.live_path(Endpoint, BearingsWeb.DailiesLive.Show, owner.username, daily)
    )
  end

  def goal_body(goal) do
    css("[data-test='goal'][data-test-id='#{goal.id}'] [data-test='body']", text: goal.body)
  end

  def personal_journal do
    css("[data-test='personal_journal']")
  end

  def goal_completed(goal) do
    text =
      case goal.completed do
        true -> "☑"
        false -> "☐"
      end

    css("[data-test='goal'][data-test-id='#{goal.id}'] [data-test='completed']", text: text)
  end
end
