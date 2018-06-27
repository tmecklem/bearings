defmodule Bearings.Repo.Migrations.RenameSupportersToAlliances do
  use Ecto.Migration

  def change do
    rename table(:supporters), to: table(:alliances)
  end
end
