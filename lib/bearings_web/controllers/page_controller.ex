defmodule BearingsWeb.PageController do
  use BearingsWeb, :controller

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, nil) do
    render(conn, "index.html")
  end

  def index(conn, _params, _) do
    redirect(conn, to: dailies_path(conn, :index))
  end
end
