defmodule Bearings.UserFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Bearings.Account.User{
          email: sequence(:email, &"test#{&1}@example.com"),
          github_id: sequence(:github_id, &"#{&1}"),
          username: sequence(:username, &"login#{&1}"),
          name: sequence(:name, &"Tim #{&1}")
        }
      end
    end
  end
end
