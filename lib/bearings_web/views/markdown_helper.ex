defmodule BearingsWeb.MarkdownHelper do
  @moduledoc """
  This module contains helper functions for rendering markdown
  """

  alias Bearings.Dailies.Markdown
  alias Phoenix.HTML

  def to_html(%Markdown{raw: markdown}) do
    case Earmark.as_html(markdown) do
      {:ok, html, _} -> HTML.raw(html)
      _ -> nil
    end
  end

  defimpl Phoenix.HTML.Safe, for: Bearings.Dailies.Markdown do
    def to_iodata(daily), do: daily.raw
  end
end
