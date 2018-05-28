defmodule Bearings.Account.Supporter do
  @moduledoc """
  Struct and functions to repesent supporters.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Account.User

  schema "supporters" do
    belongs_to(:user, User)
    belongs_to(:supporter, User)
    field(:include_private, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(supporter, attrs) do
    supporter
    |> cast(attrs, [:user_id, :supporter_id, :include_private])
    |> validate_required([:user_id, :supporter_id, :include_private])
  end
end
