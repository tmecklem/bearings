defmodule Bearings.Dailies.Markdown do
  @moduledoc """
  This module defines a custom `Ecto.Type` for a field containing Markdown.
  """

  @typedoc @moduledoc
  @type t :: %__MODULE__{raw: String.t()}

  defstruct ~w(raw)a

  @behaviour Ecto.Type

  @impl Ecto.Type
  def cast(%__MODULE__{} = mod), do: {:ok, mod}

  @impl Ecto.Type
  def cast(markdown) when is_binary(markdown) do
    {:ok, %__MODULE__{raw: markdown}}
  end

  @impl Ecto.Type
  def cast(_), do: :error

  @impl Ecto.Type
  def dump(%__MODULE__{raw: raw}) do
    {:ok, raw}
  end

  @impl Ecto.Type
  def dump(_), do: :error

  @impl Ecto.Type
  def load(raw) do
    {:ok, %__MODULE__{raw: raw}}
  end

  @impl Ecto.Type
  def type, do: :string

  defimpl Inspect, for: Bearings.Dailies.Markdown do
    def inspect(daily, _) do
      "#Bearings.Dailies.Markdown<#{daily.raw}>"
    end
  end
end
