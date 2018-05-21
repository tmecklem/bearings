defmodule BearingsWeb.DailyControllerTest do
  use BearingsWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user)
    conn = assign(conn, :current_user, user)
    my_dailies = insert_list(4, :daily, owner_id: user.id)
    _others = insert_list(4, :daily)

    {:ok, conn: conn, my_dailies: my_dailies, user: user}
  end

  test "index", %{conn: conn} do
    conn = get(conn, "/dailies")

    assert 4 == length(conn.assigns.dailies)
  end

  test "create", %{conn: conn} do
    params = params_for(:daily, owner_id: nil)
    conn = post(conn, "dailies", daily: params)

    assert redirected_to(conn) =~ ~r[/dailies/\d+]
    assert get_flash(conn, :info) != nil
  end
end
