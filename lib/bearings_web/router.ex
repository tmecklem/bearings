defmodule BearingsWeb.Router do
  use BearingsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
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

    get("/", PageController, :index)
  end

  scope "/:username", BearingsWeb do
    pipe_through(:browser)

    resources("/dailies", DailyController, as: :daily)
    delete("/goals/:id", GoalController, :delete)
  end

  scope "/auth", BearingsWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :index)
    get("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end
end
