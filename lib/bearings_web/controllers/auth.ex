defmodule BearingsWeb.Auth do
  @moduledoc """
  This module contains the user fetch plug
  """

  import Plug.Conn

  alias Bearings.Account

  def init(_) do
  end

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && Account.get_user!(user_id)
    assign(conn, :current_user, user)
  end
end
