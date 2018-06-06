defmodule Bearings.Dailies.Goal do
  @moduledoc """
  This module contains an Ecto Schema and functions for working
  with daily goals
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Bearings.Dailies.Daily

  @type t :: %__MODULE__{
          body: String.t(),
          completed: boolean,
          daily: Daily.t()
        }

  schema "goals" do
    field(:body, :string)
    field(:completed, :boolean)
    field(:index, :integer)
    field(:mark_for_delete, :boolean, virtual: true)
    belongs_to(:daily, Daily)

    timestamps()
  end

  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:body, :completed, :index, :mark_for_delete])
    |> maybe_mark_for_delete()
    |> validate_required([:body, :index])
  end

  defp maybe_mark_for_delete(changeset) do
    cond do
      get_change(changeset, :mark_for_delete) ->
        if get_field(changeset, :id) do
          %{changeset | action: :delete}
        else
          %{changeset | action: :ignore}
        end

      get_field(changeset, :body) == nil || String.trim(get_field(changeset, :body)) == "" ->
        if get_field(changeset, :id) do
          changeset = delete_change(changeset, :body)
          %{changeset | action: :delete}
        else
          %{changeset | action: :ignore}
        end

      true ->
        changeset
    end
  end
end
