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
    belongs_to(:daily, Daily)

    timestamps()
  end

  def filter_attrs(%{"goals" => goals}) do
    Enum.reduce(goals, %{}, fn {key, goal_attrs}, acc ->
      case String.length(goal_attrs["body"]) > 0 do
        true -> %{acc | key => goal_attrs}
        false -> acc
      end
    end)
  end

  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
