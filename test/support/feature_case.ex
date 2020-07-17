defmodule BearingsWeb.FeatureCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Bearings.Repo
  alias BearingsWeb.{Endpoint, FakeOAuthServer}
  alias Ecto.Adapters.SQL.Sandbox
  alias Wallaby.Browser

  using do
    quote do
      use Wallaby.DSL

      alias Bearings.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Bearings.Factory
      import BearingsWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Bearings.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    session = Browser.resize_window(session, 1400, 900)

    auth_server = FakeOAuthServer.open()

    settings =
      Application.get_env(:bearings, Bearings.OAuth.GitHub)
      |> Keyword.merge(
        site: "http://localhost:#{auth_server.port}",
        authorize_url: "http://localhost:#{auth_server.port}/authorize",
        token_url: "http://localhost:#{auth_server.port}/access_token",
        redirect_uri: Endpoint.url() <> "/auth/github/callback"
      )

    Application.put_env(:bearings, Bearings.OAuth.GitHub, settings)

    {:ok, session: session, auth_server: auth_server}
  end
end
