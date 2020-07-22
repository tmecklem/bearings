defmodule ViewingDailiesFromOtherUsersTest do
  use BearingsWeb.FeatureCase

  alias Bearings.Repo
  alias BearingsWeb.{DailiesIndexPage, DailiesShowPage}
  alias BearingsWeb.FakeOAuthServer
  alias BearingsWeb.Page
  alias Ecto.Changeset

  setup %{session: session, auth_server: auth_server} do
    other_user = insert(:user)
    user = insert(:user)

    supporter = insert(:supporter, user: other_user, supporter: user)

    FakeOAuthServer.set_user_response(auth_server, user)
    Page.login(session, user)

    {:ok, user: user, other_user: other_user, supporter: supporter}
  end

  test "viewing a list of another user's daily plans as a supporter", %{
    session: session,
    other_user: other_user
  } do
    insert(:daily, owner_id: other_user.id)

    session
    |> DailiesIndexPage.visit_page()
    |> assert_has(DailiesIndexPage.dailies(count: 1))
  end

  test "attempting to view a list of another user's daily plans when not a supporter", %{
    session: session,
    other_user: other_user,
    supporter: supporter
  } do
    Repo.delete!(supporter)
    daily = insert(:daily, owner_id: other_user.id)

    session
    |> DailiesIndexPage.visit_page()
    |> assert_has(DailiesIndexPage.dailies(count: 0))

    session
    |> DailiesShowPage.visit_page(other_user, daily)

    assert DailiesIndexPage.on_page?(session)
  end

  test "viewing another user's dailies does not show the journal by default", %{
    session: session,
    other_user: other_user
  } do
    daily =
      insert(:daily, owner_id: other_user.id, personal_journal: "This is a personal thought")

    session
    |> DailiesShowPage.visit_page(other_user, daily)
    |> refute_has(DailiesShowPage.personal_journal())
  end

  test "viewing another user's dailies does show the journal when include_private is set", %{
    session: session,
    other_user: other_user,
    supporter: supporter
  } do
    supporter
    |> Changeset.change(include_private: true)
    |> Repo.update!()

    daily =
      insert(:daily, owner_id: other_user.id, personal_journal: "This is a personal thought")

    session
    |> DailiesShowPage.visit_page(other_user, daily)
    |> assert_has(DailiesShowPage.personal_journal())
  end
end
