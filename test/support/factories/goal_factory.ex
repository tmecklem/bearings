defmodule Bearings.GoalFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def goal_factory do
        %Bearings.Dailies.Goal{body: "Goal", completed: false}
      end
    end
  end
end
