defmodule BearingsWeb.DailyControllerTest do
  use BearingsWeb.ConnCase

  import Ecto.Query
  import BearingsWeb.Router.Helpers, only: [dailies_path: 2, daily_path: 3, daily_path: 4]

  alias Bearings.Dailies.Goal

  setup %{conn: conn} do
    user = insert(:user)
    conn = assign(conn, :current_user, user)
    my_dailies = insert_list(4, :daily, owner_id: user.id)
    _others = insert_list(4, :daily)

    {:ok, conn: conn, my_dailies: my_dailies, user: user}
  end

  describe "as owner" do
    test "index", %{conn: conn} do
      conn = get(conn, dailies_path(conn, :index))

      assert 4 == length(conn.assigns.dailies)
    end

    test "create", %{conn: conn, user: %{username: username}} do
      params = params_for(:daily, owner_id: nil)
      conn = post(conn, "/#{username}/dailies", daily: params)

      assert redirected_to(conn) =~ ~r[/dailies/\d+]
      assert get_flash(conn, :info) != nil
    end

    test "show", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)
      conn = get(conn, daily_path(conn, :show, user, daily))

      assert html_response(conn, 200)
      assert conn.assigns.daily.id == daily.id
    end

    test "update", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)
      params = params_for(:daily, owner_id: nil)
      conn = put(conn, daily_path(conn, :update, user, daily), daily: params)

      assert redirected_to(conn) =~ ~r[/dailies/\d+]
      assert get_flash(conn, :info) != nil
    end

    test "update removes goals marked for delete", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)
      goal = insert(:goal, daily: daily)

      params = %{
        "goals" => [%{"mark_for_delete" => "true", "id" => goal.id}]
      }

      conn = put(conn, daily_path(conn, :update, user, daily), daily: params)

      assert redirected_to(conn) =~ ~r[/dailies/\d+]
      assert get_flash(conn, :info) != nil
      assert is_nil(Bearings.Repo.get(Goal, goal.id))
    end

    test "update removes goals with empty body", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)
      goal_1 = insert(:goal, daily: daily)
      goal_2 = insert(:goal, daily: daily)

      params = %{
        "goals" => [
          %{"body" => "", "id" => goal_1.id},
          %{"body" => " ", "id" => goal_2.id}
        ]
      }

      conn = put(conn, daily_path(conn, :update, user, daily), daily: params)

      assert redirected_to(conn) =~ ~r[/dailies/\d+]
      assert get_flash(conn, :info) != nil
      assert is_nil(Bearings.Repo.get(Goal, goal_1.id))
      assert is_nil(Bearings.Repo.get(Goal, goal_2.id))
    end

    test "update adds new goals", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)

      params = %{
        "goals" => [
          %{"body" => "Watch me succeed!"}
        ]
      }

      conn = put(conn, daily_path(conn, :update, user, daily), daily: params)

      assert redirected_to(conn) =~ ~r[/dailies/\d+]
      assert get_flash(conn, :info) != nil
      refute is_nil(Bearings.Repo.one(from(g in Goal, where: g.body == ^"Watch me succeed!")))
    end

    test "update ignores new goals with empty body", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)
      params = %{"goals" => [%{"body" => " "}]}
      conn = put(conn, daily_path(conn, :update, user, daily), daily: params)

      assert redirected_to(conn) =~ ~r[/dailies/\d+]
      assert get_flash(conn, :info) != nil

      assert is_nil(
               Bearings.Repo.one(
                 from(g in Goal, join: d in assoc(g, :daily), where: d.id == ^daily.id)
               )
             )
    end

    test "delete", %{conn: conn, user: user} do
      daily = insert(:daily, owner_id: user.id)
      conn = delete(conn, daily_path(conn, :delete, user, daily))

      assert redirected_to(conn) =~ ~r[/dailies]
      assert get_flash(conn, :info) != nil
    end
  end

  describe "as accountability partner" do
    setup %{conn: conn, user: user} do
      other = insert(:user)
      insert(:supporter, supporter: user, user: other, include_private: true)
      other_dailies = insert_list(4, :daily, owner_id: other.id)

      {:ok, conn: conn, other_user: other, other_dailies: other_dailies}
    end

    test "can see index", %{
      conn: conn,
      other_dailies: other_dailies
    } do
      conn = get(conn, dailies_path(conn, :index))

      other_ids =
        other_dailies
        |> Enum.map(& &1.id)

      actual_ids =
        conn.assigns.dailies
        |> Enum.map(& &1.id)

      assert 8 == length(conn.assigns.dailies)
      assert 4 == length(actual_ids -- other_ids)
    end

    test "create", %{conn: conn, other_user: user} do
      conn = post(conn, daily_path(conn, :create, user))
      assert html_response(conn, 404)
    end

    test "show includes private section", %{conn: conn, other_user: user} do
      daily = insert(:daily, owner_id: user.id)
      conn = get(conn, daily_path(conn, :show, user, daily))

      assert html_response(conn, 200)
      assert conn.assigns.daily.id == daily.id
      assert conn.assigns.daily.personal_journal != nil
    end

    test "cannot update a daily", %{conn: conn, other_user: user} do
      other_daily = insert(:daily, owner_id: user.id)
      conn = put(conn, daily_path(conn, :update, user, other_daily))
      assert html_response(conn, 404)
    end

    test "cannot delete a daily", %{conn: conn, other_user: user} do
      other_daily = insert(:daily, owner_id: user.id)
      conn = delete(conn, daily_path(conn, :delete, user, other_daily))
      assert html_response(conn, 404)
    end
  end

  describe "as supporter" do
    setup %{conn: conn, user: user} do
      other = insert(:user)
      insert(:supporter, supporter: user, user: other, include_private: false)
      other_dailies = insert_list(4, :daily, owner_id: other.id)

      {:ok, conn: conn, other_user: other, other_dailies: other_dailies}
    end

    test "can see index without private journal", %{
      conn: conn,
      other_dailies: other_dailies,
      other_user: user
    } do
      conn = get(conn, dailies_path(conn, :index))

      other_ids =
        other_dailies
        |> Enum.map(& &1.id)

      actual_ids =
        conn.assigns.dailies
        |> Enum.map(& &1.id)

      scrubbed_daily = Enum.find(conn.assigns.dailies, fn daily -> daily.owner == user end)

      assert 8 == length(conn.assigns.dailies)
      assert 4 == length(actual_ids -- other_ids)
      refute is_nil(scrubbed_daily)
      assert is_nil(scrubbed_daily.personal_journal)
    end

    test "create", %{conn: conn, other_user: user} do
      conn = post(conn, daily_path(conn, :create, user))
      assert html_response(conn, 404)
    end

    test "show without private section", %{conn: conn, other_user: user} do
      daily = insert(:daily, owner_id: user.id)
      conn = get(conn, daily_path(conn, :show, user, daily))

      assert html_response(conn, 200)
      assert conn.assigns.daily.id == daily.id
      assert conn.assigns.daily.personal_journal == nil
    end

    test "cannot update a daily", %{conn: conn, other_user: user} do
      other_daily = insert(:daily, owner_id: user.id)
      conn = put(conn, daily_path(conn, :update, user, other_daily))
      assert html_response(conn, 404)
    end

    test "cannot delete a daily", %{conn: conn, other_user: user} do
      other_daily = insert(:daily, owner_id: user.id)
      conn = delete(conn, daily_path(conn, :delete, user, other_daily))
      assert html_response(conn, 404)
    end
  end

  describe "with no supporter/accountability relationship" do
    setup do
      other = insert(:user)
      insert_list(4, :daily, owner_id: other.id)
      other_daily = insert(:daily, owner_id: other.id)

      {:ok, other_user: other, other_daily: other_daily}
    end

    test "cannot create", %{conn: conn, other_user: user} do
      conn = post(conn, daily_path(conn, :create, user))
      assert html_response(conn, 404)
    end

    test "cannot view a daily", %{conn: conn, other_user: user, other_daily: daily} do
      conn = get(conn, daily_path(conn, :show, user, daily))
      assert html_response(conn, 404)
    end

    test "cannot update a daily", %{conn: conn, other_user: user, other_daily: daily} do
      conn = put(conn, daily_path(conn, :update, user, daily))
      assert html_response(conn, 404)
    end

    test "cannot delete a daily", %{conn: conn, other_user: user, other_daily: daily} do
      conn = delete(conn, daily_path(conn, :delete, user, daily))
      assert html_response(conn, 404)
    end
  end
end
