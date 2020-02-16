defmodule BearingsWeb.Router do
  use BearingsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BearingsWeb.Auth, repo: Bearings.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BearingsWeb do
    pipe_through(:browser)

    resources("/dailies", DailyController, as: :dailies, only: [:index])
    resources("/template", TemplateController, only: [:edit, :create, :update], singleton: true)

    get("/", PageController, :index)
  end

  scope "/:username", BearingsWeb do
    pipe_through(:browser)

    live "/dailies/new", DailiesLive.New
    resources("/dailies", DailyController, as: :daily, except: [:new])
  end

  scope "/auth", BearingsWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :index)
    get("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end
end
