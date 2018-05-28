defmodule Bearings.DailiesTest do
  use Bearings.DataCase

  alias Bearings.Dailies
  alias Bearings.Dailies.Markdown

  describe "dailies" do
    alias Bearings.Dailies.Daily

    @valid_attrs %{
      date: ~D[2010-04-17],
      private_markdown: "some private_markdown",
      public_markdown: "some public_markdown"
    }
    @update_attrs %{
      date: ~D[2011-05-18],
      private_markdown: "some updated private_markdown",
      public_markdown: "some updated public_markdown"
    }
    @invalid_attrs %{date: nil, private_markdown: nil, public_markdown: nil}

    test "list_dailies/0 returns all dailies" do
      user = insert(:user)
      daily = insert(:daily, owner_id: user.id)
      assert Dailies.list_dailies(user.github_login) == [daily]
    end

    test "get_daily!/2 returns the daily with given date and username" do
      user = insert(:user)
      daily = insert(:daily, owner_id: user.id)
      assert Dailies.get_daily!(daily.date, user.github_login) == daily
    end

    test "create_daily/1 with valid data creates a daily" do
      user = insert(:user)
      attrs = Map.put(@valid_attrs, :owner_id, user.id)
      assert {:ok, %Daily{} = daily} = Dailies.create_daily(attrs)
      assert daily.date == ~D[2010-04-17]
      assert %Markdown{raw: "some private_markdown"} = daily.private_markdown
      assert %Markdown{raw: "some public_markdown"} = daily.public_markdown
    end

    test "create_daily/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dailies.create_daily(@invalid_attrs)
    end

    test "update_daily/2 with valid data updates the daily" do
      daily = insert(:daily)
      assert {:ok, daily} = Dailies.update_daily(daily, @update_attrs)
      assert %Daily{} = daily
      assert daily.date == ~D[2011-05-18]
      assert %Markdown{raw: "some updated private_markdown"} = daily.private_markdown
      assert %Markdown{raw: "some updated public_markdown"} = daily.public_markdown
    end

    test "update_daily/2 with invalid data returns error changeset" do
      user = insert(:user)
      daily = insert(:daily, owner_id: user.id)
      assert {:error, %Ecto.Changeset{}} = Dailies.update_daily(daily, @invalid_attrs)
      assert daily == Dailies.get_daily!(daily.date, user.github_login)
    end

    test "delete_daily/1 deletes the daily" do
      user = insert(:user)
      daily = insert(:daily, owner_id: user.id)
      assert {:ok, %Daily{}} = Dailies.delete_daily(daily)

      assert_raise Ecto.NoResultsError, fn ->
        Dailies.get_daily!(daily.date, user.github_login)
      end
    end

    test "change_daily/1 returns a daily changeset" do
      daily = insert(:daily)
      assert %Ecto.Changeset{} = Dailies.change_daily(daily)
    end
  end
end
