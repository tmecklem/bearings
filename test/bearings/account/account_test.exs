defmodule Bearings.AccountTest do
  use Bearings.DataCase

  alias Bearings.Account

  describe "users" do
    alias Bearings.Account.User

    @valid_attrs %{
      email: "some email",
      github_id: "some github_id",
      username: "some github_username"
    }
    @update_attrs %{
      email: "some updated email",
      github_id: "some updated github_id",
      username: "some updated github_username"
    }
    @invalid_attrs %{email: nil, github_id: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.github_id == "some github_id"
      assert user.username == "some github_username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.github_id == "some updated github_id"
      assert user.username == "some updated github_username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "alliances" do
    alias Bearings.Account.Alliance

    @valid_attrs %{include_private: true, supporter_id: 42, user_id: 42}
    @update_attrs %{include_private: false, supporter_id: 43, user_id: 43}
    @invalid_attrs %{include_private: nil, supporter_id: nil, user_id: nil}

    def alliance_fixture(attrs \\ %{}) do
      {:ok, alliance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_alliance()

      alliance
    end

    test "get_alliance!/1 returns the alliance with given id" do
      alliance = alliance_fixture()
      assert Account.get_alliance!(alliance.id) == alliance
    end

    test "create_alliance/1 with valid data creates a alliance" do
      assert {:ok, %Alliance{} = alliance} = Account.create_alliance(@valid_attrs)
      assert alliance.include_private == true
      assert alliance.supporter_id == 42
      assert alliance.user_id == 42
    end

    test "create_alliance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_alliance(@invalid_attrs)
    end

    test "update_alliance/2 with valid data updates the alliance" do
      alliance = alliance_fixture()
      assert {:ok, alliance} = Account.update_alliance(alliance, @update_attrs)
      assert %Alliance{} = alliance
      assert alliance.include_private == false
      assert alliance.supporter_id == 43
      assert alliance.user_id == 43
    end

    test "update_alliance/2 with invalid data returns error changeset" do
      alliance = alliance_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_alliance(alliance, @invalid_attrs)
      assert alliance == Account.get_alliance!(alliance.id)
    end

    test "delete_alliance/1 deletes the alliance" do
      alliance = alliance_fixture()
      assert {:ok, %Alliance{}} = Account.delete_alliance(alliance)
      assert_raise Ecto.NoResultsError, fn -> Account.get_alliance!(alliance.id) end
    end

    test "change_alliance/1 returns a alliance changeset" do
      alliance = alliance_fixture()
      assert %Ecto.Changeset{} = Account.change_alliance(alliance)
    end
  end
end
