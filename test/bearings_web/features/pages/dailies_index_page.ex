defmodule BearingsWeb.DailiesIndexPage do
  @moduledoc """
  Module to interact with dailies index pages
  """

  use Hound.Helpers

  import BearingsWeb.Router.Helpers, only: [dailies_path: 2]

  alias BearingsWeb.Endpoint

  def visit_page do
    navigate_to(dailies_path(Endpoint, :index))
  end

  def dailies do
    find_all_elements(:css, "[data-test='daily']")
  end
end
