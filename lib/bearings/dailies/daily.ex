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
          private_markdown: Markdown.t(),
          public_markdown: Markdown.t()
        }

  schema "dailies" do
    field(:date, :date)
    field(:private_markdown, Markdown)
    field(:public_markdown, Markdown)
    field(:owner_id, :integer)

    timestamps()
  end

  def strip_private_markdown(%__MODULE__{} = daily) do
    %{daily | private_markdown: nil}
  end

  @doc false
  def changeset(daily, attrs) do
    daily
    |> cast(attrs, [:date, :owner_id, :public_markdown, :private_markdown])
    |> validate_required([:date, :owner_id, :public_markdown, :private_markdown])
  end
end
