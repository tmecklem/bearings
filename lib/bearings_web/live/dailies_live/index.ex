defmodule BearingsWeb.DailiesLive.Index do
  @moduledoc """
  This module is responsible to handle listing dailies
  """
  use BearingsWeb, :live_view

  alias Bearings.Account
  alias Bearings.Dailies
  alias Bearings.Dailies.Daily

  def mount(_params, session, socket) do
    user_id = session["user_id"]

    socket =
      if socket.assigns[:current_user] do
        socket
      else
        user = user_id && Account.get_user!(user_id)
        assign(socket, :current_user, user)
      end

    dailies =
      socket.assigns[:current_user]
      |> Dailies.list_dailies(include_supports: true, days: 60)
      |> Enum.map(&Daily.strip_private_markdown/1)

    {:ok, assign(socket, dailies: dailies)}
  end
end
