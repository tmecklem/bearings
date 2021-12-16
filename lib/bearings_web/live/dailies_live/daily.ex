defmodule BearingsWeb.DailiesLive.Daily do
  @moduledoc false

  use Phoenix.Component

  def daily(assigns) do
    Phoenix.View.render(BearingsWeb.LiveView, "dailies_live/daily.html", assigns)
  end
end
