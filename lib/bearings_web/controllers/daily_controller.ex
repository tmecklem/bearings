defmodule BearingsWeb.DailyController do
  use BearingsWeb, :controller

  alias Bearings.Dailies
  alias Bearings.Dailies.Daily

  plug(:authenticate when action in [:new, :create, :edit, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def create(conn, %{"daily" => daily_params}, %{id: user_id}) do
    daily_params
    |> Map.put("owner_id", user_id)
    |> Dailies.create_daily()
    |> case do
      {:ok, daily} ->
        conn
        |> put_flash(:info, "Created Successfully")
        |> redirect(to: daily_path(conn, :show, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, _user) do
    daily = Dailies.get_daily!(id)
    changeset = Dailies.change_daily(daily)

    render(conn, "edit.html", changeset: changeset, daily: daily)
  end

  def index(conn, _params, %{id: user_id}) do
    dailies = Dailies.list_dailies(user_id)
    render(conn, "index.html", dailies: dailies)
  end

  def index(conn, _params, _) do
    render(conn, "index.html", dailies: [])
  end

  def new(conn, _params, _user) do
    changeset = Dailies.change_daily(%Daily{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}, _user) do
    daily = Dailies.get_daily!(id)
    render(conn, "show.html", daily: daily)
  end

  def update(conn, %{"id" => id, "daily" => daily_params}, _user) do
    daily = Dailies.get_daily!(id)

    case Dailies.update_daily(daily, daily_params) do
      {:ok, daily} ->
        conn
        |> put_flash(:info, "Updated Successfully")
        |> redirect(to: daily_path(conn, :show, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, daily: daily)
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to manage dailies")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
