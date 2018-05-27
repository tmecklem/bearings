defmodule BearingsWeb.DailyController do
  use BearingsWeb, :controller

  alias Bearings.Account
  alias Bearings.Account.Supporter
  alias Bearings.Dailies
  alias Bearings.Dailies.Daily

  plug(:authenticate)
  plug(:authorize_owner when action in [:new, :create, :edit, :update, :delete])
  plug(:authorize_supporter_or_owner when action in [:index, :show])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [
      conn,
      conn.params,
      %{user: conn.assigns.current_user, supporter: conn.assigns[:supporter]}
    ])
  end

  def create(conn, %{"daily" => daily_params}, %{user: user}) do
    daily_params
    |> Map.put("owner_id", user.id)
    |> Dailies.create_daily()
    |> case do
      {:ok, daily} ->
        conn
        |> put_flash(:info, "Created Successfully")
        |> redirect(to: daily_path(conn, :show, user, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, _user) do
    daily = Dailies.get_daily!(id)
    changeset = Dailies.change_daily(daily)

    render(conn, "edit.html", changeset: changeset, daily: daily)
  end

  def index(conn, %{"username" => username}, %{supporter: %Supporter{accountable: false}}) do
    dailies =
      username
      |> Dailies.list_dailies()
      |> Enum.map(&Daily.strip_private_markdown/1)

    render(conn, "index.html", dailies: dailies)
  end

  def index(conn, %{"username" => username}, assigns) do
    dailies =
      username
      |> Dailies.list_dailies()
      |> Enum.map(fn daily -> maybe_strip_private(daily, assigns) end)

    render(conn, "index.html", dailies: dailies)
  end

  def new(conn, _params, _) do
    changeset = Dailies.change_daily(%Daily{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id, "username" => username}, assigns) do
    id
    |> Dailies.get_daily!(username)
    |> case do
      %Daily{} = daily ->
        daily = maybe_strip_private(daily, assigns)
        render(conn, "show.html", daily: daily)

      nil ->
        render(conn, BearingsWeb.ErrorView, "404.html")
    end
  end

  def show(conn, %{"id" => id}, _) do
    daily = Dailies.get_daily!(id)
    render(conn, "show.html", daily: daily)
  end

  def update(conn, %{"id" => id, "daily" => daily_params}, %{user: user}) do
    daily = Dailies.get_daily!(id)

    case Dailies.update_daily(daily, daily_params) do
      {:ok, daily} ->
        conn
        |> put_flash(:info, "Updated Successfully")
        |> redirect(to: daily_path(conn, :show, user, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, daily: daily)
    end
  end

  def delete(conn, params, %{user: user}) do
    params["id"]
    |> Dailies.get_daily!()
    |> Dailies.delete_daily()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Daily successfully deleted")
        |> redirect(to: daily_path(conn, :index, user))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not delete daily")
        |> redirect(to: daily_path(conn, :index, user, changeset.id))
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

  defp authorize_owner(conn, _opts) do
    if conn.assigns.current_user.github_login == conn.params["username"] do
      conn
    else
      conn
      |> put_status(:not_found)
      |> render(BearingsWeb.ErrorView, "404.html")
      |> halt()
    end
  end

  defp authorize_supporter_or_owner(conn, _opts) do
    cond do
      conn.assigns.current_user.github_login == conn.params["username"] ->
        conn

      supporter =
          Account.find_supporter(
            supporter: conn.assigns.current_user,
            owner_username: conn.params["username"]
          ) ->
        assign(conn, :supporter, supporter)

      true ->
        conn
        |> put_status(:not_found)
        |> render(BearingsWeb.ErrorView, "404.html")
        |> halt()
    end
  end

  defp maybe_strip_private(daily, %{supporter: %Supporter{accountable: false}}) do
    Daily.strip_private_markdown(daily)
  end

  defp maybe_strip_private(daily, _), do: daily
end
