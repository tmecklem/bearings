defmodule BearingsWeb.DailiesIndexPage do
  @moduledoc """
  Module to interact with dailies index pages
  """

  use Wallaby.DSL

  import BearingsWeb.Router.Helpers, only: [daily_path: 3]
  import Wallaby.Query, only: [css: 2]

  alias BearingsWeb.Endpoint

  def visit_page(session, user) do
    visit(session, daily_path(Endpoint, :index, user))
  end

  def dailies(count: count) do
    css("[data-test='daily']", count: count)
  end
end
