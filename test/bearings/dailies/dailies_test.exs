defmodule Bearings.DailiesTest do
  use Bearings.DataCase

  alias Bearings.Dailies
  alias Bearings.Dailies.Markdown
  alias Bearings.Dailies.Daily

  @valid_attrs %{
    date: ~D[2010-04-17],
    personal_journal: "some personal_journal",
    daily_plan: "some daily_plan"
  }
  @update_attrs %{
    date: ~D[2011-05-18],
    personal_journal: "some updated personal_journal",
    daily_plan: "some updated daily_plan"
  }
  @invalid_attrs %{date: nil, personal_journal: nil, daily_plan: nil}

  describe "list_dailies/2" do
    setup do
      user = insert(:user)
      other_user = insert(:user)
      insert(:supporter, user: other_user, supporter: user)

      daily_id = insert(:daily, owner_id: user.id).id
      other_id = insert(:daily, owner_id: other_user.id).id

      {:ok, user: user, daily_id: daily_id, other_id: other_id}
    end

    test "list_dailies/2 returns all user's dailies", %{user: user, daily_id: daily_id} do
      assert 1 == length(Dailies.list_dailies(user))
      assert %Daily{id: ^daily_id} = hd(Dailies.list_dailies(user))
    end

    test "list_dailies/2 returns all user's dailies and the user's supports' dailies when include_supports: true",
         %{user: user, daily_id: daily_id, other_id: other_id} do
      actual_ids =
        user
        |> Dailies.list_dailies(include_supports: true)
        |> Enum.map(& &1.id)

      assert 2 == length(actual_ids)
      assert actual_ids -- [daily_id, other_id] == []
    end
  end

  test "get_daily!/2 returns the daily with given date and username" do
    user = insert(:user)
    daily = insert(:daily, owner_id: user.id) |> Repo.preload(:goals)
    assert Dailies.get_daily!(daily.date, user.username) == daily
  end

  test "create_daily/1 with valid data creates a daily" do
    user = insert(:user)
    attrs = Map.put(@valid_attrs, :owner_id, user.id)
    assert {:ok, %Daily{} = daily} = Dailies.create_daily(attrs)
    assert daily.date == ~D[2010-04-17]
    assert %Markdown{raw: "some personal_journal"} = daily.personal_journal
    assert %Markdown{raw: "some daily_plan"} = daily.daily_plan
  end

  test "create_daily/1 with invalid goal data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} =
             Dailies.create_daily(Map.put(@valid_attrs, :goals, [%{body: ""}]))
  end

  test "create_daily/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Dailies.create_daily(@invalid_attrs)
  end

  test "update_daily/2 with valid data updates the daily" do
    daily = insert(:daily)
    assert {:ok, daily} = Dailies.update_daily(daily, @update_attrs)
    assert %Daily{} = daily
    assert daily.date == ~D[2011-05-18]
    assert %Markdown{raw: "some updated personal_journal"} = daily.personal_journal
    assert %Markdown{raw: "some updated daily_plan"} = daily.daily_plan
  end

  test "update_daily/2 with invalid data returns error changeset" do
    user = insert(:user)
    daily = insert(:daily, owner_id: user.id) |> Repo.preload(:goals)
    assert {:error, %Ecto.Changeset{}} = Dailies.update_daily(daily, @invalid_attrs)
    assert daily == Dailies.get_daily!(daily.date, user.username)
  end

  test "delete_daily/1 deletes the daily" do
    user = insert(:user)
    daily = insert(:daily, owner_id: user.id)
    assert {:ok, %Daily{}} = Dailies.delete_daily(daily)

    assert_raise Ecto.NoResultsError, fn ->
      Dailies.get_daily!(daily.date, user.username)
    end
  end

  test "change_daily/1 returns a daily changeset" do
    daily = insert(:daily)
    assert %Ecto.Changeset{} = Dailies.change_daily(daily)
  end

  test "get_adjacent/1 returns the previous and next daily ids for the daily's owner" do
    owner = insert(:user)

    %Daily{id: yesterday_id} =
      yesterday = insert(:daily, date: ~D[2015-05-01], owner_id: owner.id)

    %Daily{id: tomorrow_id} = tomorrow = insert(:daily, date: ~D[2015-05-03], owner_id: owner.id)
    %Daily{id: today_id} = today = insert(:daily, date: ~D[2015-05-02], owner_id: owner.id)

    assert {nil, %Daily{id: ^today_id}} =
             Dailies.get_adjacent(owner_id: yesterday.owner_id, date: yesterday.date)

    assert {%Daily{id: ^yesterday_id}, %Daily{id: ^tomorrow_id}} =
             Dailies.get_adjacent(owner_id: today.owner_id, date: today.date)

    assert {%Daily{id: ^today_id}, nil} =
             Dailies.get_adjacent(owner_id: tomorrow.owner_id, date: tomorrow.date)
  end

  describe "templates" do
    alias Bearings.Dailies.Template

    @valid_attrs %{daily_plan: "some daily_plan", owner_id: 42, personal_journal: "some personal_journal"}
    @update_attrs %{daily_plan: "some updated daily_plan", owner_id: 43, personal_journal: "some updated personal_journal"}
    @invalid_attrs %{daily_plan: nil, owner_id: nil, personal_journal: nil}

    def template_fixture(attrs \\ %{}) do
      {:ok, template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dailies.create_template()

      template
    end

    test "list_templates/0 returns all templates" do
      template = template_fixture()
      assert Dailies.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = template_fixture()
      assert Dailies.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      assert {:ok, %Template{} = template} = Dailies.create_template(@valid_attrs)
      assert template.daily_plan == "some daily_plan"
      assert template.owner_id == 42
      assert template.personal_journal == "some personal_journal"
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dailies.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = template_fixture()
      assert {:ok, template} = Dailies.update_template(template, @update_attrs)
      assert %Template{} = template
      assert template.daily_plan == "some updated daily_plan"
      assert template.owner_id == 43
      assert template.personal_journal == "some updated personal_journal"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = template_fixture()
      assert {:error, %Ecto.Changeset{}} = Dailies.update_template(template, @invalid_attrs)
      assert template == Dailies.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Dailies.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Dailies.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = template_fixture()
      assert %Ecto.Changeset{} = Dailies.change_template(template)
    end
  end
end
