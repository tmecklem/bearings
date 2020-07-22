defmodule BearingsWeb.DailiesIndexPage do
  @moduledoc """
  Module to interact with dailies index pages
  """

  use Wallaby.DSL

  import Wallaby.Query, only: [css: 2]

  alias BearingsWeb.DailiesLive.Index
  alias BearingsWeb.Endpoint
  alias BearingsWeb.Router.Helpers, as: Routes

  def visit_page(session) do
    visit(session, Routes.live_path(Endpoint, Index))
  end

  def on_page?(session) do
    current_path(session) == Routes.live_path(Endpoint, Index)
  end

  def dailies(count: count) do
    css("[data-test='daily']", count: count)
  end
end
