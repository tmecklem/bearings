defmodule Bearings.DailyFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def daily_factory do
        %Bearings.Dailies.Daily{
          date: Date.utc_today(),
          owner_id: insert(:user).id,
          private_markdown: %Bearings.Dailies.Markdown{raw: "## Private"},
          public_markdown: %Bearings.Dailies.Markdown{raw: "## Public"}
        }
      end
    end
  end
end
