defmodule BearingsWeb.TemplateController do
  use BearingsWeb, :controller

  alias Bearings.Dailies
  alias Bearings.Dailies.Template

  plug(:authenticate)

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [
      conn,
      conn.params,
      %{user: conn.assigns.current_user}
    ])
  end

  def edit(conn, _, %{user: user}) do
    changeset =
      (Dailies.get_template(user) || %Template{owner_id: user.id})
      |> Dailies.change_template()

    render(
      conn,
      "edit.html",
      changeset: changeset
    )
  end

  def create(conn, %{"template" => template_params}, %{user: user}) do
    template_attrs =
      template_params
      |> Map.put("owner_id", user.id)

    case Dailies.create_template(template_attrs) do
      {:ok, _template} ->
        conn
        |> put_flash(:info, "Template Changed Successfully")
        |> redirect(to: Routes.live_path(conn, BearingsWeb.DailiesLive.Index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          changeset: changeset
        )
    end
  end

  def update(conn, %{"template" => template_params}, %{user: user}) do
    template = Dailies.get_template(user)

    template_attrs =
      template_params
      |> Map.put("owner_id", user.id)

    case Dailies.update_template(template, template_attrs) do
      {:ok, _template} ->
        conn
        |> put_flash(:info, "Template Changed Successfully")
        |> redirect(to: Routes.live_path(conn, BearingsWeb.DailiesLive.Index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          changeset: changeset
        )
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to manage dailies")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
