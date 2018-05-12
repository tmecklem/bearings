defmodule BearingsWeb.FeatureCase do
  @moduledoc false

  use ExUnit.CaseTemplate

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
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bearings.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Bearings.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Bearings.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    session = Browser.resize_window(session, 1400, 900)
    {:ok, session: session}
  end
end
