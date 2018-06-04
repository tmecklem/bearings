defmodule BearingsWeb.GoalController do
  use BearingsWeb, :controller

  alias Bearings.Dailies

  plug(BearingsWeb.Auth when action in [:delete])

  def delete(conn, %{"id" => id, "username" => _user}) do
    goal = Dailies.get_goal!(id)

    if goal.daily.owner_id == conn.assigns.current_user.id do
      with {:ok, _} <- Dailies.delete_goal(goal) do
        conn
        |> put_flash(:info, "Goal successfully deleted")
        |> redirect(to: daily_path(conn, :edit, conn.assigns.current_user, goal.daily))
      end
    else
      conn
      |> put_status(:not_found)
      |> render(BearingsWeb.ErrorView, "404.html")
      |> halt()
    end
  end
end
