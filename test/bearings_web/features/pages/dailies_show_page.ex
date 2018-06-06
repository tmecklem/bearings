defmodule BearingsWeb.DailiesShowPage do
  @moduledoc """
  Module to interact with dailies show pages
  """

  use Wallaby.DSL

  import BearingsWeb.Router.Helpers, only: [dailies_path: 3]
  import Wallaby.Query, only: [css: 2]

  alias BearingsWeb.Endpoint

  def visit_page(session, daily) do
    visit(session, dailies_path(Endpoint, :show, daily))
  end

  def goal_body(goal) do
    css("[data-test='goal'][data-test-id='#{goal.id}'] [data-test='body']", text: goal.body)
  end

  def goal_completed(goal) do
    text =
      case goal.completed do
        true ->
          "☑"

        false ->
          "☐"
      end

    css("[data-test='goal'][data-test-id='#{goal.id}'] [data-test='completed']", text: text)
  end
end
