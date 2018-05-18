defmodule Bearings.UserFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Bearings.Account.User{
          email: "test@example.com",
          github_id: "1353",
          github_login: "test"
        }
      end
    end
  end
end
