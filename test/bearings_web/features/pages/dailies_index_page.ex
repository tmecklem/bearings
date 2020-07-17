defmodule BearingsWeb.DailiesIndexPage do
  @moduledoc """
  Module to interact with dailies index pages
  """

  use Hound.Helpers

  alias BearingsWeb.Router.Helpers, as: Routes

  alias BearingsWeb.DailiesLive.Index
  alias BearingsWeb.Endpoint

  def visit_page do
    navigate_to(Routes.live_path(Endpoint, Index))
  end

  def dailies do
    find_all_elements(:css, "[data-test='daily']")
  end
end
