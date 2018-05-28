defmodule Bearings.DailyFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def daily_factory do
        %Bearings.Dailies.Daily{
          date: sequence(:date, fn seq -> Timex.shift(Date.utc_today(), days: -seq) end),
          owner_id: insert(:user).id,
          private_markdown: %Bearings.Dailies.Markdown{raw: "## Private"},
          public_markdown: %Bearings.Dailies.Markdown{raw: "## Public"}
        }
      end
    end
  end
end
