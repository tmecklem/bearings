defmodule BearingsWeb.DailyController do
  use BearingsWeb, :controller

  alias Bearings.Account
  alias Bearings.Account.Supporter
  alias Bearings.Dailies
  alias Bearings.Dailies.Daily

  plug(:authenticate)
  plug(:authorize_owner when action in [:create, :update, :delete])
  plug(:authorize_supporter_or_owner when action in [:show])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [
      conn,
      conn.params,
      %{user: conn.assigns.current_user, supporter: conn.assigns[:supporter]}
    ])
  end

  def create(conn, %{"daily" => daily_params} = params, %{user: user}) do
    daily_params
    |> Map.put("owner_id", user.id)
    |> Dailies.create_daily()
    |> case do
      {:ok, daily} ->
        if params["previous_daily"] do
          {previous, _next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)
          {:ok, _} = Dailies.update_goals(previous, params["previous_daily"])
        end

        conn
        |> put_flash(:info, "Created Successfully")
        |> redirect(to: daily_path(conn, :show, user, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        date =
          case Timex.parse(daily_params["date"], "%Y-%m-%d", :strftime) do
            {:ok, date_time} -> Timex.to_date(date_time)
            _ -> Timex.today()
          end

        {previous, next} = Dailies.get_adjacent(owner_id: user.id, date: date)
        render(conn, "new.html", changeset: changeset, previous_daily: previous, next_daily: next)
    end
  end

  # temporary redirect for old /username/dailies path
  def index(conn, %{"username" => _}, _assigns) do
    redirect(conn, to: dailies_path(conn, :index))
  end

  def index(conn, _params, %{user: user}) do
    dailies =
      user
      |> Dailies.list_dailies(include_supports: true, days: 60)
      |> Enum.map(&Daily.strip_private_markdown/1)

    render(conn, "index.html", dailies: dailies)
  end

  def show(conn, %{"id" => date_string, "username" => username}, assigns) do
    date_string
    |> parse_date()
    |> Dailies.get_daily!(username)
    |> case do
      %Daily{} = daily ->
        daily = maybe_strip_private(daily, assigns)
        {previous, next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)
        render(conn, "show.html", daily: daily, previous_daily: previous, next_daily: next)

      nil ->
        render(conn, BearingsWeb.ErrorView, "404.html")
    end
  end

  def update(
        conn,
        %{"daily" => daily_params, "id" => date_string, "username" => username} = params,
        %{
          user: user
        }
      ) do
    daily =
      date_string
      |> parse_date()
      |> Dailies.get_daily!(username)

    case Dailies.update_daily(daily, daily_params) do
      {:ok, _daily_changeset} ->
        if params["previous_daily"] do
          {previous, _next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)
          {:ok, _} = Dailies.update_goals(previous, params["previous_daily"])
        end

        conn
        |> put_flash(:info, "Updated Successfully")
        |> redirect(to: daily_path(conn, :show, user, daily))

      {:error, %Ecto.Changeset{} = changeset} ->
        {previous, next} = Dailies.get_adjacent(owner_id: daily.owner_id, date: daily.date)

        render(
          conn,
          "edit.html",
          changeset: changeset,
          daily: daily,
          previous_daily: previous,
          next_daily: next
        )
    end
  end

  def delete(conn, %{"id" => date_string, "username" => username}, _) do
    date_string
    |> parse_date()
    |> Dailies.get_daily!(username)
    |> Dailies.delete_daily()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Daily successfully deleted")
        |> redirect(to: dailies_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Could not delete daily")
        |> redirect(to: dailies_path(conn, :index))
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
    if conn.assigns.current_user.username == conn.params["username"] do
      conn
    else
      conn
      |> put_status(:not_found)
      |> put_view(BearingsWeb.ErrorView)
      |> render("404.html")
      |> halt()
    end
  end

  defp authorize_supporter_or_owner(conn, _opts) do
    cond do
      conn.assigns.current_user.username == conn.params["username"] ->
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
        |> put_view(BearingsWeb.ErrorView)
        |> render("404.html")
        |> halt()
    end
  end

  defp maybe_strip_private(daily, %{supporter: %Supporter{include_private: false}}) do
    Daily.strip_private_markdown(daily)
  end

  defp maybe_strip_private(daily, _), do: daily

  defp parse_date(date_string) do
    case Timex.parse(date_string, "{YYYY}-{M}-{D}") do
      {:ok, datetime} ->
        Timex.to_date(datetime)

      _ ->
        nil
    end
  end
end
