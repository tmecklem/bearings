defmodule BearingsWeb.PageController do
  use BearingsWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: daily_path(conn, :index))
  end
end
