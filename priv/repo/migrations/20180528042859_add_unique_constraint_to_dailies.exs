defmodule Bearings.Repo.Migrations.AddUniqueConstraintToDailies do
  use Ecto.Migration

  def change do
    create unique_index(:dailies, [:owner_id, :date], name: :unique_owner_id_date)
  end
end
