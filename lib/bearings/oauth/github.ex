defmodule Bearings.OAuth.GitHub do
  @moduledoc """
  An OAuth2 strategy for GitHub.
  """
  use OAuth2.Strategy

  alias Bearings.OAuth.GitHub
  alias OAuth2.Client
  alias OAuth2.Strategy.AuthCode

  # Public API

  def client do
    Application.get_env(:bearings, __MODULE__)
    |> Keyword.merge(strategy: GitHub)
    |> Client.new()
    |> Client.put_serializer("application/vnd.api+json", Jason)
    |> Client.put_serializer("application/json", Jason)
  end

  def authorize_url!(params \\ []) do
    Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    Client.get_token!(
      client(),
      Keyword.merge(params, client_secret: client().client_secret)
    )
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, Keyword.merge(params, scope: "user:email"))
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
