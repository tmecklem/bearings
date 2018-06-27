defmodule Bearings.Account.Alliance do
  @moduledoc """
  Struct and functions to repesent an alliance between a user and a supporter.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Account.User

  schema "alliances" do
    belongs_to(:user, User)
    belongs_to(:supporter, User)
    field(:include_private, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(alliance, attrs) do
    alliance
    |> cast(attrs, [:user_id, :supporter_id, :include_private])
    |> validate_required([:user_id, :supporter_id, :include_private])
  end
end
