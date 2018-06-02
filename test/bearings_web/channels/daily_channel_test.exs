defmodule BearingsWeb.DailyChannelTest do
  use BearingsWeb.ChannelCase

  alias Bearings.Dailies.{Daily, Goal}
  alias BearingsWeb.{UserSocket, DailyView}

  setup do
    user = insert(:user)
    daily = insert(:daily, owner_id: user.id)

    {:ok, socket} = connect(UserSocket, %{})

    {:ok, _, socket} =
      subscribe_and_join(socket, "dailies:#{daily.date}", %{"username" => user.username})

    {:ok, socket: socket, user: user, daily: daily}
  end

  describe "handle_in/3" do
    test "add_goal", %{socket: socket, daily: daily} do
      push(socket, "add_goal", %{})
      new_goals = daily.goals ++ [%Goal{}]

      expected_response = DailyView.render_goal_fields(%Daily{daily | goals: new_goals})

      assert_push("new_goal_form", %{html: ^expected_response})
    end
  end
end
