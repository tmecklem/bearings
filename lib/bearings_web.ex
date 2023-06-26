defmodule BearingsWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BearingsWeb, :controller
      use BearingsWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def controller do
    quote do
      use Phoenix.Controller, namespace: BearingsWeb
      import Plug.Conn
      import BearingsWeb.Gettext
      import Phoenix.LiveView.Controller, only: [live_render: 3]

      unquote(verified_routes())

      alias BearingsWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/bearings_web/templates",
        namespace: BearingsWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {BearingsWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  # since this app came along from traditional through early liveview releases,
  # some of the templating is not broken up ideally into components.
  # This is largely a stopgap for that transition work
  def live_view_subtemplate do
    quote do
      use Phoenix.View,
        root: "lib/bearings_web",
        namespace: BearingsWeb,
        pattern: "**/*"

      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      # import Phoenix.LiveView.Helpers
      import Phoenix.Component
      import BearingsWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import BearingsWeb.ErrorHelpers
      import BearingsWeb.Gettext
      import BearingsWeb.MarkdownHelper

      unquote(verified_routes())

      alias BearingsWeb.Router.Helpers, as: Routes
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: BearingsWeb.Endpoint,
        router: BearingsWeb.Router,
        statics: BearingsWeb.static_paths()
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BearingsWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
