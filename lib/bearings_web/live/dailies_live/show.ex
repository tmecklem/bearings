defmodule BearingsWeb.DailiesLive.Show do
  @moduledoc """
  This module is responsible to display a daily
  """
  use Phoenix.LiveView

  alias Bearings.Account
  alias Bearings.Dailies
  alias Bearings.Dailies.Daily
  alias BearingsWeb.DailyView
  alias BearingsWeb.Router.Helpers, as: Routes
  alias Phoenix.View

  def mount(%{"id" => date_string, "username" => username}, session, socket) do
    user_id = session["user_id"]

    socket =
      if socket.assigns[:current_user] do
        socket
      else
        user = user_id && Account.get_user!(user_id)
        assign(socket, :current_user, user)
      end

    daily =
      date_string
      |> parse_date()
      |> Dailies.get_daily!(username)

    changeset = Dailies.change_daily(daily)

    {previous, next} =
      Dailies.get_adjacent(owner_id: socket.assigns.current_user.id, date: daily.date)

    {:ok,
     assign(socket, changeset: changeset, daily: daily, previous_daily: previous, next_daily: next)}
  end

  def render(assigns), do: View.render(DailyView, "show.html", assigns)

  def handle_event("validate", %{"daily" => daily_params}, socket) do
    changeset =
      %Daily{}
      |> Dailies.change_daily(daily_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("delete", _, socket) do
    socket =
      socket.assigns[:daily]
      |> Dailies.delete_daily()
      |> case do
        {:ok, _} ->
          socket
          |> put_flash(:info, "Daily successfully deleted")
          |> redirect(to: Routes.live_path(socket, BearingsWeb.DailiesLive.Index))

        {:error, _} ->
          socket
          |> put_flash(:error, "Could not delete daily")
          |> redirect(to: Routes.live_path(socket, BearingsWeb.DailiesLive.Index))
      end

    {:noreply, socket}
  end

  defp parse_date(date_string) do
    case Timex.parse(date_string, "{YYYY}-{M}-{D}") do
      {:ok, datetime} ->
        Timex.to_date(datetime)

      _ ->
        nil
    end
  end
end
