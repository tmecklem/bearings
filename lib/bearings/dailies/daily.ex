defmodule Bearings.Dailies.Daily do
  @moduledoc """
  This module contains an Ecto Schema and related functions for daily planning
  data.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Dailies.Markdown

  @type t :: %__MODULE__{
          date: Date.t(),
          personal_journal: Markdown.t(),
          daily_plan: Markdown.t()
        }

  schema "dailies" do
    field(:date, :date)
    field(:personal_journal, Markdown)
    field(:daily_plan, Markdown)
    field(:owner_id, :integer)

    timestamps()
  end

  def strip_private_markdown(%__MODULE__{} = daily) do
    %{daily | personal_journal: nil}
  end

  @doc false
  def changeset(daily, attrs) do
    daily
    |> cast(attrs, [:date, :owner_id, :daily_plan, :personal_journal])
    |> validate_required([:date, :owner_id, :daily_plan])
    |> unique_constraint(:date, name: :unique_owner_id_date)
  end
end
