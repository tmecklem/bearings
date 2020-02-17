defmodule BearingsWeb.DailiesLive.Edit do
  @moduledoc """
  This module is responsible to handle editing a daily
  """
  use Phoenix.LiveView

  alias Bearings.Account
  alias Bearings.Dailies
  alias Bearings.Dailies.Daily
  alias BearingsWeb.DailyView
  alias BearingsWeb.Router.Helpers, as: Routes
  alias Ecto.Changeset
  alias Phoenix.View

  def mount(%{"id" => date_string, "username" => username}, session, socket) do
    user_id = session["user_id"]

    socket = if socket.assigns[:current_user] do
      socket
    else
      user = user_id && Account.get_user!(user_id)
      assign(socket, :current_user, user)
    end

    date =
      date_string
      |> parse_date()

    daily = Dailies.get_daily!(date, username)

    changeset =
      daily
      |> Dailies.change_daily()
      |> Changeset.put_assoc(:goals, daily.goals ++ [%Bearings.Dailies.Goal{}])

    previous_changeset =
      case Dailies.get_adjacent(owner_id: socket.assigns.current_user.id, date: date) do
        {%Daily{} = previous, _} ->
          Dailies.change_daily(previous)
        _ -> nil
      end

    {:ok, assign(socket, changeset: changeset, previous_changeset: previous_changeset, daily: daily)}
  end

  def render(assigns), do: View.render(DailyView, "edit.html", assigns)

  def handle_event("validate", %{"daily" => daily_params} = params, socket) do
    changeset =
      socket.assigns[:daily]
      |> Dailies.change_daily(daily_params)
      |> Map.put(:action, :insert)

    changeset =
      changeset
      |> Changeset.put_assoc(:goals, Changeset.get_field(changeset, :goals) ++ [%Bearings.Dailies.Goal{}])

    socket = case params["previous_daily"] do
               nil ->
                 socket
               _ ->
                 previous_changeset =
                   socket.assigns.previous_changeset
                   |> Daily.goals_changeset(params["previous_daily"])
                 assign(socket, previous_changeset: previous_changeset)
             end

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"daily" => daily_params} = params, socket) do
    daily = socket.assigns[:daily]

    socket =
      case Dailies.update_daily(daily, daily_params) do
        {:ok, _daily_changeset} ->
          if params["previous_daily"] do
            {previous, _next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)
            {:ok, _} = Dailies.update_goals(previous, params["previous_daily"])
          end

          socket
          |> put_flash(:info, "Updated Successfully")
          |> redirect(to: Routes.live_path(socket, BearingsWeb.DailiesLive.Show, socket.assigns[:current_user], daily))

        {:error, %Changeset{} = changeset} ->
          {previous, next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)

          assign(socket, changeset: changeset, daily: daily, previous_daily: previous, next_daily: next)
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
