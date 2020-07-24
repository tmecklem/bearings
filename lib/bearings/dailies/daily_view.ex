defmodule Bearings.Dailies.DailyView do
  @moduledoc """
  This module contains an Ecto Schema and related functions for views of a daily
  data.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Account.User
  alias Bearings.Dailies.Daily

  @type t :: %__MODULE__{
          daily_id: Daily.t(),
          date: DateTime.t(),
          viewer_id: User.t()
        }

  schema "daily_views" do
    field(:date, :utc_datetime)
    belongs_to(:daily, Daily)
    belongs_to(:viewer, User)

    timestamps()
  end

  @doc false
  def changeset(daily_view, attrs) do
    daily_view
    |> cast(attrs, [:date, :viewer_id, :daily_id])
    |> cast_assoc(:viewer)
    |> cast_assoc(:daily)
    |> validate_required([:date, :viewer_id, :daily_id])
    |> unique_constraint([:viewer_id, :daily_id])
  end
end
