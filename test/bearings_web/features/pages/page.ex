defmodule BearingsWeb.Page do
  @moduledoc false

  use Wallaby.DSL

  import Wallaby.Browser
  import Wallaby.Query, only: [css: 1, css: 2]

  def flash_info do
    css("[data-test='flash_info']")
  end

  def login(session, user) do
    session
    |> visit("/")
    |> click(css("[data-test='login']"))
    |> assert_has(css("[data-test='current_user']", text: user.name))
  end
end
