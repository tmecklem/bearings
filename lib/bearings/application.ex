defmodule Bearings.Application do
  @moduledoc false
  use Application

  alias BearingsWeb.Endpoint

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Bearings.Repo, []),
      supervisor(BearingsWeb.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: Bearings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
