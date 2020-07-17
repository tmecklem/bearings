defmodule BearingsWeb.Router do
  use BearingsWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {BearingsWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BearingsWeb.Auth, repo: Bearings.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BearingsWeb do
    pipe_through(:browser)

    live("/dailies", DailiesLive.Index)
    resources("/template", TemplateController, only: [:edit, :create, :update], singleton: true)

    get("/", PageController, :index)
  end

  scope "/:username", BearingsWeb do
    pipe_through(:browser)

    live("/dailies/new", DailiesLive.New)
    live("/dailies/:id/edit", DailiesLive.Edit)
    live("/dailies/:id", DailiesLive.Show)
  end

  scope "/auth", BearingsWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :index)
    get("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end
end
