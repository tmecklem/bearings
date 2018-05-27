defmodule Bearings.SupporterFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def supporter_factory do
        %Bearings.Account.Supporter{
          user: insert(:user),
          supporter: insert(:user)
        }
      end
    end
  end
end
