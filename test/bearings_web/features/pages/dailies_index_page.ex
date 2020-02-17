defmodule BearingsWeb.DailiesIndexPage do
  @moduledoc """
  Module to interact with dailies index pages
  """

  use Hound.Helpers

  import BearingsWeb.Router.Helpers

  alias BearingsWeb.DailiesLive.Index
  alias BearingsWeb.Endpoint

  def visit_page do
    navigate_to(live_path(Endpoint, Index))
  end

  def dailies do
    find_all_elements(:css, "[data-test='daily']")
  end
end
