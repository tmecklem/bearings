defmodule Bearings.Repo.Migrations.AddOwnerToDailies do
  use Ecto.Migration

  def change do
    alter table(:dailies) do
      add :owner_id, references(:users), null: false
    end
  end
end
