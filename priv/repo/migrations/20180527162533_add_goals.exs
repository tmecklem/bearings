defmodule Bearings.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :body, :string
      add :completed, :boolean, default: false
      add :daily_id, references(:dailies)

      timestamps()
    end
  end
end
