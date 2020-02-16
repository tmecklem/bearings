defmodule BearingsWeb.DailiesLive.New do
  use Phoenix.LiveView

  alias Bearings.Account
  alias Bearings.Dailies
  alias Bearings.Dailies.{Daily, Template}

  # alias BearingsWeb.Router.Helpers, as: Routes

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

    {previous, next} = Dailies.get_adjacent(owner_id: socket.assigns.current_user.id, date: date)

    {:ok, assign(socket, changeset: changeset, previous_daily: previous, next_daily: next)}
  end

  def render(assigns), do: Phoenix.View.render(BearingsWeb.DailyView, "new.html", assigns)

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
end
