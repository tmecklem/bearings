defmodule Bearings.AllianceFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def alliance_factory do
        %Bearings.Account.Alliance{
          user: insert(:user),
          supporter: insert(:user)
        }
      end
    end
  end
end
