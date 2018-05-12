defmodule BearingsWeb.DailyController do
  use BearingsWeb, :controller

  alias Bearings.Dailies
  alias Bearings.Dailies.Daily

  def create(conn, %{"daily" => daily_params}) do
    case Dailies.create_daily(daily_params) do
      {:ok, daily} ->
        conn
        |> put_flash(:info, "Created Successfully")
        |> redirect(to: daily_path(conn, :show, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    daily = Dailies.get_daily!(id)
    changeset = Dailies.change_daily(daily)

    render(conn, "edit.html", changeset: changeset, daily: daily)
  end

  def index(conn, _params) do
    dailies = Dailies.list_dailies()
    render(conn, "index.html", dailies: dailies)
  end

  def new(conn, _params) do
    changeset = Dailies.change_daily(%Daily{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    daily = Dailies.get_daily!(id)
    render(conn, "show.html", daily: daily)
  end

  def update(conn, %{"id" => id, "daily" => daily_params}) do
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
end
