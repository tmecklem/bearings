defmodule BearingsWeb.PageController do
  use BearingsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
