defmodule Bearings.Repo.Migrations.CreateSupporters do
  use Ecto.Migration

  def change do
    create table(:supporters) do
      add :user_id, :integer
      add :supporter_id, :integer
      add :accountable, :boolean, default: false, null: false

      timestamps()
    end

  end
end
