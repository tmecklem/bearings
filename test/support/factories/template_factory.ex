defmodule Bearings.TemplateFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def template_factory do
        %Bearings.Dailies.Template{
          daily_plan:
            sequence(
              :template_daily_plan,
              &%Bearings.Dailies.Markdown{raw: "## Public Template #{&1}"}
            ),
          owner: build(:user),
          personal_journal:
            sequence(
              :template_daily_plan,
              &%Bearings.Dailies.Markdown{raw: "## Private Template #{&1}"}
            )
        }
      end
    end
  end
end
