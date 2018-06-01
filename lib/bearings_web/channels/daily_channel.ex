defmodule BearingsWeb.DailyChannel do
  use Phoenix.Channel

  alias Bearings.Dailies
  alias Bearings.Dailies.{Daily, Goal}
  alias BearingsWeb.DailyView

  ########
  # JOIN #
  ########

  def join("dailies:" <> daily_date, %{"username" => user}, socket) do
    send(self(), {:after_join, Daily.parse_date(daily_date), user})

    {:ok, %{}, socket}
  end

  #####################
  # INCOMING MESSAGES #
  #####################

  def handle_in("add_goal", _params, socket) do
    socket = update_daily(socket, :add_goal)
    push(socket, "new_goal_form", %{html: DailyView.render_goal_fields(socket.assigns.daily)})
    {:noreply, socket}
  end

  def handle_in("remove_goal", _params, socket) do
    socket = update_daily(socket, :remove_one_unsaved)
    push(socket, "new_goal_form", %{html: DailyView.render_goal_fields(socket.assigns.daily)})
    {:noreply, socket}
  end

  def handle_in("remove_goal" <> id, _params, socket) do
    with {:ok, _} <- Dailies.get_goal!(id) |> Dailies.delete_goal() do
      socket = update_daily(socket, :refetch)
      push(socket, "new_goal_form", %{html: DailyView.render_goal_fields(socket.assigns.daily)})
      {:noreply, socket}
    else
      _ -> {:reply, {:error, %{message: "Could not delete goal"}}, socket}
    end
  end

  ############
  # INTERNAL #
  ############

  def handle_info({:after_join, daily_date, username}, socket) do
    socket = assign(socket, :daily, Dailies.get_daily!(daily_date, username))
    |> assign(:username, username)
    {:noreply, socket}
  end

  ####################
  # HELPER FUNCTIONS #
  ####################

  defp update_daily(%{assigns: %{daily: daily}} = socket, :add_goal) do
    assign(socket, :daily, %Daily{ daily | goals: daily.goals ++ [%Goal{}]})
  end

  defp update_daily(%{assigns: %{daily: daily}} = socket, :refetch) do
    {_, unsaved} = unsaved_goals(daily)
    daily = Dailies.get_daily!(daily.date, socket.assigns.username)
    assign(socket, :daily, %Daily{ daily | goals: daily.goals ++ unsaved})
  end

  defp update_daily(%{assigns: %{daily: daily}} = socket, :remove_one_unsaved) do
    assign(socket, :daily, drop_one_unsaved_goal(daily))
  end

  defp unsaved_goals(daily) do
    Enum.split_with(daily.goals, &(&1.id))
  end

  defp drop_one_unsaved_goal(daily) do
    {saved, unsaved} = unsaved_goals(daily)
    %Daily{ daily | goals: saved ++ Enum.drop(unsaved, 1)}
  end
end
