defmodule Bearings.Repo.Migrations.CreateDailyViews do
  use Ecto.Migration

  def change do
    create table(:daily_views) do
      add :date, :utc_datetime
      add :daily_id, :integer
      add :viewer_id, :integer

      timestamps()
    end
  end
end
