defmodule Bearings.UserFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Bearings.Account.User{
          email: sequence(:email, &"test#{&1}@example.com"),
          github_id: sequence(:github_id, &"#{&1}"),
          github_login: sequence(:github_login, &"login#{&1}")
        }
      end
    end
  end
end
