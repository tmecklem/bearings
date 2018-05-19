defmodule BearingsWeb.DailyControllerTest do
  use BearingsWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user)
    conn = assign(conn, :current_user, user)
    my_dailies = insert_list(4, :daily, owner_id: user.id)
    _others = insert_list(4, :daily)

    {:ok, conn: conn, my_dailies: my_dailies}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/dailies")

    assert 4 == length(conn.assigns.dailies)
  end
end
