defmodule Bearings.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :owner_id, references(:users), null: false
      add :daily_plan, :text
      add :personal_journal, :text

      timestamps()
    end

  end
end
