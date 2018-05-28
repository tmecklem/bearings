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

  describe "supporters" do
    alias Bearings.Account.Supporter

    @valid_attrs %{include_private: true, supporter_id: 42, user_id: 42}
    @update_attrs %{include_private: false, supporter_id: 43, user_id: 43}
    @invalid_attrs %{include_private: nil, supporter_id: nil, user_id: nil}

    def supporter_fixture(attrs \\ %{}) do
      {:ok, supporter} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_supporter()

      supporter
    end

    test "list_supporters/0 returns all supporters" do
      supporter = supporter_fixture()
      assert Account.list_supporters() == [supporter]
    end

    test "get_supporter!/1 returns the supporter with given id" do
      supporter = supporter_fixture()
      assert Account.get_supporter!(supporter.id) == supporter
    end

    test "create_supporter/1 with valid data creates a supporter" do
      assert {:ok, %Supporter{} = supporter} = Account.create_supporter(@valid_attrs)
      assert supporter.include_private == true
      assert supporter.supporter_id == 42
      assert supporter.user_id == 42
    end

    test "create_supporter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_supporter(@invalid_attrs)
    end

    test "update_supporter/2 with valid data updates the supporter" do
      supporter = supporter_fixture()
      assert {:ok, supporter} = Account.update_supporter(supporter, @update_attrs)
      assert %Supporter{} = supporter
      assert supporter.include_private == false
      assert supporter.supporter_id == 43
      assert supporter.user_id == 43
    end

    test "update_supporter/2 with invalid data returns error changeset" do
      supporter = supporter_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_supporter(supporter, @invalid_attrs)
      assert supporter == Account.get_supporter!(supporter.id)
    end

    test "delete_supporter/1 deletes the supporter" do
      supporter = supporter_fixture()
      assert {:ok, %Supporter{}} = Account.delete_supporter(supporter)
      assert_raise Ecto.NoResultsError, fn -> Account.get_supporter!(supporter.id) end
    end

    test "change_supporter/1 returns a supporter changeset" do
      supporter = supporter_fixture()
      assert %Ecto.Changeset{} = Account.change_supporter(supporter)
    end
  end
end
