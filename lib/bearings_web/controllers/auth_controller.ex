defmodule BearingsWeb.AuthController do
  use BearingsWeb, :controller

  alias Bearings.OAuth.GitHub
  alias Bearings.Account
  alias OAuth2.Client

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect(conn, external: authorize_url!(provider))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    oauth_user = get_user!(provider, client)
    {:ok, user} = Account.find_or_create_from_github(oauth_user)

    conn
    |> put_session(:user_id, user.id)
    |> put_session(:access_token, client.token.access_token)
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end

  defp authorize_url!("github"), do: GitHub.authorize_url!()
  defp authorize_url!(_), do: raise("No matching provider available")

  defp get_token!("github", code), do: GitHub.get_token!(code: code)
  defp get_token!(_, _), do: raise("No matching provider available")

  defp get_user!("github", client) do
    %{body: user} = Client.get!(client, "/user")

    email =
      case user["email"] do
        nil ->
          %{body: emails} = Client.get!(client, "/user/emails")
          primary_or_first_email(emails, nil)

        email ->
          email
      end

    %{
      email: email,
      name: user["name"],
      github_id: user["id"] |> Integer.to_string(),
      username: user["login"],
      avatar: user["avatar_url"]
    }
  end

  defp primary_or_first_email([], current), do: current

  defp primary_or_first_email([%{"primary" => true, "email" => email} | _], _) do
    email
  end

  defp primary_or_first_email([%{"email" => email} | tail], current) do
    primary_or_first_email(tail, current || email)
  end
end
