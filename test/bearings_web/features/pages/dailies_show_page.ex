defmodule BearingsWeb.DailiesShowPage do
  @moduledoc """
  Module to interact with dailies show pages
  """

  use Hound.Helpers

  import BearingsWeb.Router.Helpers

  alias BearingsWeb.Endpoint

  def visit_page(daily) do
    navigate_to(live_path(Endpoint, BearingsWeb.DailiesLive.Show, daily))
  end

  def goal_body(goal) do
    visible_text({:css, "[data-test='goal'][data-test-id='#{goal.id}'] [data-test='body']"})
  end

  def goal_completed(goal) do
    case visible_text(
           {:css, "[data-test='goal'][data-test-id='#{goal.id}'] [data-test='completed']"}
         ) do
      "☑" -> true
      "☐" -> false
    end
  end
end
