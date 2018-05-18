defmodule Bearings.Account.User do
  @moduledoc """
  This module contains functions and Ecto schema related to a user account.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:avatar, :string)
    field(:email, :string)
    field(:github_id, :string)
    field(:github_login, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:avatar, :email, :github_id, :github_login, :name])
    |> validate_required([:email, :github_login, :github_id])
  end
end
