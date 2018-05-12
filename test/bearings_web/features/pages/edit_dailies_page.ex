defmodule BearingsWeb.EditDailiesPage do
  @moduledoc """
  Module to interact with dailies add/edit pages
  """

  use Wallaby.DSL

  import Wallaby.Query, only: [css: 1]

  alias Bearings.Dailies.Daily

  def visit_add_page(session) do
    visit(session, "/dailies/new")
  end

  def visit_edit_page(session, daily) do
    visit(session, "/dailies/#{daily.id}/edit")
  end

  def fill_form(session, %Daily{} = daily) do
    session
    |> fill_in(css("[data-test='date']"), with: Timex.format!(daily.date, "%F", :strftime))
    |> fill_in(css("[data-test='private_markdown']"), with: daily.private_markdown.raw)
    |> fill_in(css("[data-test='public_markdown']"), with: daily.public_markdown.raw)
  end

  def save(session) do
    click(session, css("[data-test='save_daily']"))
  end
end
