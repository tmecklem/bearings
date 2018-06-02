defmodule BearingsWeb.DailiesIndexPage do
  @moduledoc """
  Module to interact with dailies index pages
  """

  use Wallaby.DSL

  import BearingsWeb.Router.Helpers, only: [dailies_path: 2]
  import Wallaby.Query, only: [css: 2]

  alias BearingsWeb.Endpoint

  def visit_page(session) do
    visit(session, dailies_path(Endpoint, :index))
  end

  def dailies(count: count) do
    css("[data-test='daily']", count: count)
  end
end
