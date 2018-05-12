defmodule BearingsWeb.ErrorView do
  use BearingsWeb, :view

  alias Phoenix.Controller

  def template_not_found(template, _assigns) do
    Controller.status_message_from_template(template)
  end
end
