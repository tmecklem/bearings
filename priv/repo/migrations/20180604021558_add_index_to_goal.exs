defmodule Bearings.Repo.Migrations.AddIndexToGoal do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :index, :integer
    end
  end
end
