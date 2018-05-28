defmodule Bearings.Repo.Migrations.ClarifyDomainTerminology do
  use Ecto.Migration

  def change do
    rename table("supporters"), :accountable, to: :include_private
    rename table("users"), :github_login, to: :username
    rename table("dailies"), :public_markdown, to: :daily_plan
    rename table("dailies"), :private_markdown, to: :personal_journal
  end
end
