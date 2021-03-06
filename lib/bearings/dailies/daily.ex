defmodule Bearings.Dailies.Daily do
  @moduledoc """
  This module contains an Ecto Schema and related functions for daily planning
  data.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Account.User
  alias Bearings.Dailies.{DailyView, Goal, Markdown}

  @type t :: %__MODULE__{
          daily_plan: Markdown.t(),
          date: Date.t(),
          goals: list(Goal.t()),
          owner_id: User.t(),
          personal_journal: Markdown.t()
        }

  schema "dailies" do
    field(:date, :date)
    field(:personal_journal, Markdown)
    field(:daily_plan, Markdown)
    belongs_to(:owner, User)
    has_many(:goals, Goal, on_delete: :delete_all)
    has_many(:daily_views, DailyView, on_delete: :delete_all)

    timestamps()
  end

  def maybe_strip_private_markdown(%__MODULE__{} = daily, true = _include_private), do: daily

  def maybe_strip_private_markdown(%__MODULE__{} = daily, _include_private),
    do: strip_private_markdown(daily)

  def strip_private_markdown(%__MODULE__{} = daily) do
    %{daily | personal_journal: nil}
  end

  @doc false
  def goals_changeset(daily, attrs) do
    daily
    |> cast(attrs, [])
    |> cast_assoc(:goals)
  end

  @doc false
  def changeset(daily, attrs) do
    daily
    |> cast(attrs, [:date, :owner_id, :daily_plan, :personal_journal])
    |> cast_assoc(:goals)
    |> validate_required([:date, :owner_id, :daily_plan])
    |> unique_constraint(:date, name: :unique_owner_id_date)
  end

  @doc """
  Parses a date string into a DateTime struct
  """
  @spec parse_date(String.t()) :: DateTime.t() | nil
  def parse_date(date_string) do
    case Timex.parse(date_string, "{YYYY}-{M}-{D}") do
      {:ok, datetime} ->
        Timex.to_date(datetime)

      _ ->
        nil
    end
  end
end
