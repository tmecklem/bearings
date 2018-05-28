defmodule Bearings.Repo.Migrations.AddUserContraints do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:username], name: :unique_username)
    create unique_index(:users, [:email], name: :unique_email)
  end
end
