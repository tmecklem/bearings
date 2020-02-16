defmodule BearingsWeb.DailiesLive.Edit do
  use Phoenix.LiveView

  alias Bearings.Account
  alias Bearings.Dailies
  alias Bearings.Dailies.Daily

  def mount(%{"id" => date_string, "username" => username}, session, socket) do
    user_id = session["user_id"]

    socket = if socket.assigns[:current_user] do
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

    {previous, next} = Dailies.get_adjacent(owner_id: socket.assigns.current_user.id, date: daily.date)

    {:ok, assign(socket, changeset: changeset, daily: daily, previous_daily: previous, next_daily: next)}
  end

  def render(assigns), do: Phoenix.View.render(BearingsWeb.DailyView, "edit.html", assigns)

  def handle_event("validate", %{"daily" => daily_params}, socket) do
    changeset =
      %Daily{}
      |> Dailies.change_daily(daily_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  # def handle_event("save", %{"user" => user_params}, socket) do
  #   case Accounts.create_user(user_params) do
  #     {:ok, user} ->
  #       {:stop,
  #        socket
  #        |> put_flash(:info, "user created")
  #        |> redirect(to: Routes.live_path(socket, UserLive.Show, user))}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end

  defp parse_date(date_string) do
    case Timex.parse(date_string, "{YYYY}-{M}-{D}") do
      {:ok, datetime} ->
        Timex.to_date(datetime)

      _ ->
        nil
    end
  end
end
