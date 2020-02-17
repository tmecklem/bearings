defmodule BearingsWeb.DailiesLive.New do
  use Phoenix.LiveView

  alias Bearings.Account
  alias Bearings.Dailies
  alias Bearings.Dailies.{Daily, Template}

  alias BearingsWeb.Router.Helpers, as: Routes

  def mount(params, session, socket) do
    user_id = session["user_id"]

    socket = if socket.assigns[:current_user] do
      socket
    else
      user = user_id && Account.get_user!(user_id)
      assign(socket, :current_user, user)
    end

    date =
      case Timex.parse(params["date"], "%Y-%m-%d", :strftime) do
        {:ok, date_time} -> Timex.to_date(date_time)
        _ -> Timex.today()
      end

    template = Dailies.get_template(socket.assigns.current_user) || %Template{}

    changeset =
      Dailies.change_daily(
        %Daily{
          date: date,
          daily_plan: template.daily_plan,
          personal_journal: template.personal_journal
        }
      )
      |> Ecto.Changeset.put_assoc(:goals, [%Bearings.Dailies.Goal{}])

    previous_changeset =
      case Dailies.get_adjacent(owner_id: socket.assigns.current_user.id, date: date) do
        {%Daily{} = previous, _} ->
          Dailies.change_daily(previous)
        _ -> nil
      end

    {:ok, assign(socket, changeset: changeset, previous_changeset: previous_changeset)}
  end

  def render(assigns), do: Phoenix.View.render(BearingsWeb.DailyView, "new.html", assigns)

  def handle_event("validate", %{"daily" => daily_params} = params, socket) do
    changeset =
      %Daily{}
      |> Dailies.change_daily(daily_params)
      |> Map.put(:action, :insert)

    changeset =
      changeset
      |> Ecto.Changeset.put_assoc(:goals, Ecto.Changeset.get_field(changeset, :goals) ++ [%Bearings.Dailies.Goal{}])

    socket = case socket.assigns.previous_changeset do
               %Ecto.Changeset{} ->
                 previous_changeset =
                   socket.assigns.previous_changeset
                   |> Daily.goals_changeset(params["previous_daily"])
                 assign(socket, previous_changeset: previous_changeset)
               _ ->
                 socket
             end

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"daily" => daily_params} = params, socket) do
    user = socket.assigns[:current_user]

    socket =
      daily_params
      |> Map.put("owner_id", user.id)
      |> Dailies.create_daily()
      |> case do
           {:ok, daily} ->
             if params["previous_daily"] do
               {previous, _next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)
               {:ok, _} = Dailies.update_goals(previous, params["previous_daily"])
             end

             socket
             |> put_flash(:info, "Created Successfully")
             |> redirect(to: Routes.live_path(socket, BearingsWeb.DailiesLive.Show, user, daily))

           {:error, %Ecto.Changeset{} = changeset} ->
             assign(socket, changeset: changeset)
         end
      {:noreply, socket}
  end
end
