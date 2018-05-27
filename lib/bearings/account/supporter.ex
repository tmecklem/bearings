defmodule Bearings.Account.Supporter do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Account.User

  schema "supporters" do
    belongs_to :user, User
    belongs_to :supporter, User
    field :accountable, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(supporter, attrs) do
    supporter
    |> cast(attrs, [:user_id, :supporter_id, :accountable])
    |> validate_required([:user_id, :supporter_id, :accountable])
  end
end
