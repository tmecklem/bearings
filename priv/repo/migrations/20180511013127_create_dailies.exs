defmodule Bearings.Repo.Migrations.CreateDailies do
  use Ecto.Migration

  def change do
    create table(:dailies) do
      add :date, :date
      add :public_markdown, :text
      add :private_markdown, :text

      timestamps()
    end
  end
end
