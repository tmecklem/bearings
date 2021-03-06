defmodule Bearings.DailyFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def daily_factory do
        %Bearings.Dailies.Daily{
          date: sequence(:date, fn seq -> Timex.shift(Date.utc_today(), days: -seq) end),
          owner_id: insert(:user).id,
          personal_journal: %Bearings.Dailies.Markdown{raw: "## Private"},
          daily_plan: %Bearings.Dailies.Markdown{raw: "## Public"}
        }
      end

      def with_goals(daily) do
        insert_list(3, :goal, daily: daily)
        daily
      end
    end
  end
end
