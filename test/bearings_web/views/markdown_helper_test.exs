defmodule BearingsWeb.MarkdownHelperTest do
  use ExUnit.Case, async: true

  alias Bearings.Dailies.Markdown
  alias BearingsWeb.MarkdownHelper

  describe "to_html/1" do
    test "it converts a markdown struct to html" do
      content = """
      ## H2 ##
      ### H3 ###
      """

      expected_html = "<h2>H2</h2><h3>H3</h3>"

      {:safe, result} = MarkdownHelper.to_html(%Markdown{raw: content})
      assert expected_html == String.replace(result, "\n", "")
    end

    test "it handles nil" do
      assert is_nil(MarkdownHelper.to_html(nil))
    end
  end
end
