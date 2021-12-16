defmodule BearingsWeb.DailiesLive.Form do
  @moduledoc false

  use Phoenix.Component

  def daily_form(assigns) do
    Phoenix.View.render(BearingsWeb.LiveView, "dailies_live/daily_form.html", assigns)
  end
end
