defmodule Bearings.Dailies.Template do
  @moduledoc """
    This module contains functions related to daily templates. Templates are
    used to prepopulate the daily form.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bearings.Account.User
  alias Bearings.Dailies.Markdown

  @type t :: %__MODULE__{
          daily_plan: Markdown.t(),
          owner_id: User.t(),
          personal_journal: Markdown.t()
        }

  schema "templates" do
    belongs_to(:owner, User)
    field(:daily_plan, Markdown)
    field(:personal_journal, Markdown)

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:owner_id, :daily_plan, :personal_journal])
    |> validate_required([:owner_id, :daily_plan])
  end
end
