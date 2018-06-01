defmodule BearingsWeb.DailyChannelTest do
  use BearingsWeb.ChannelCase

  setup do
    user = insert(:user)
    daily = insert(:daily, owner_id: user.id)

    {:ok, socket} = connect(BearingsWeb.UserSocket, %{})

    {:ok, _, socket} =
      subscribe_and_join(socket, "dailies:#{daily.date}", %{"username" => user.username})

    {:ok, socket: socket, user: user, daily: daily}
  end

  describe "handle_in/3" do
    test "add_goal", %{socket: socket} do
      push(socket, "add_goal", %{})
      expected_response = BearingsWeb.DailyView.render_goal_fields()

      assert_push("new_goal", %{html: ^expected_response})
    end
  end
end
