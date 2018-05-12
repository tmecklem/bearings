defmodule Bearings.Dailies.Daily do
  @moduledoc """
  This module contains an Ecto Schema and related functions for daily planning
  data.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Dailies.Markdown

  @type t :: %__MODULE__{
          date: NaiveDateTime.t(),
          private_markdown: Markdown.t(),
          public_markdown: Markdown.t()
        }

  schema "dailies" do
    field(:date, :naive_datetime)
    field(:private_markdown, Markdown)
    field(:public_markdown, Markdown)

    timestamps()
  end

  @doc false
  def changeset(daily, attrs) do
    daily
    |> cast(attrs, [:date, :public_markdown, :private_markdown])
    |> validate_required([:date, :public_markdown, :private_markdown])
  end
end
