defmodule Bearings.Account.User do
  @moduledoc """
  This module contains functions and Ecto schema related to a user account.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Bearings.Account.Supporter

  @type t :: %__MODULE__{
    avatar: binary(),
    email: binary(),
    github_id: binary(),
    username: binary(),
    name: binary()
  }

  schema "users" do
    field(:avatar, :string)
    field(:email, :string)
    field(:github_id, :string)
    field(:username, :string)
    field(:name, :string)

    # relationships where this user is the supporter
    has_many(:supports, Supporter, foreign_key: :supporter_id)
    # users that this user supports
    has_many(:supports_users, through: [:supports, :user])

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:avatar, :email, :github_id, :username, :name])
    |> validate_required([:email, :username, :github_id])
    |> unique_constraint(:username, name: :unique_username)
    |> unique_constraint(:email, name: :unique_email)
  end
end
