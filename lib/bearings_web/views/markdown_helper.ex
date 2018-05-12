defmodule BearingsWeb.MarkdownHelper do
  @moduledoc """
  This module contains helper functions for rendering markdown
  """

  alias Bearings.Dailies.Markdown

  def to_html(%Markdown{raw: markdown}) do
    case Earmark.as_html(markdown) do
      {:ok, html, _} -> html
      _ -> nil
    end
  end
end
