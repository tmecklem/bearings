defmodule BearingsWeb.LiveHelpers do
  @moduledoc false
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `BearingsWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

  <%= live_modal BearingsWeb.FocusLive.FormComponent,
  id: @focus.id || :new,
  action: @live_action,
  focus: @focus,
  return_to: Routes.focus_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(BearingsWeb.ModalComponent, modal_opts)
  end
end
