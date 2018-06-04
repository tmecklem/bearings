defmodule BearingsWeb.GoalsControllerTest do
  use BearingsWeb.ConnCase

  import BearingsWeb.Router.Helpers, only: [goal_path: 4]

  setup %{conn: conn} do
    user = insert(:user)
    conn = assign(conn, :current_user, user)
    daily = insert(:daily, owner_id: user.id)
    other = insert(:daily)

    {:ok, conn: conn, daily: daily, other: other, user: user}
  end

  describe "delete/2" do
    test "deletes the goal when user is the owner", %{daily: daily, conn: conn, user: user} do
      conn = delete(conn, goal_path(conn, :delete, user, hd(daily.goals)))
      expected_date = String.replace("#{daily.date}", ~r(-0), "-")
      assert redirected_to(conn) =~ "/dailies/#{expected_date}"
      assert get_flash(conn, :info)
    end

    test "renders an error unless user owns the associated daily", %{
      other: other,
      conn: conn,
      user: user
    } do
      conn = delete(conn, goal_path(conn, :delete, user, hd(other.goals)))

      assert html_response(conn, 404)
    end
  end
end
