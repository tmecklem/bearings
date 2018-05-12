defmodule BearingsWeb.Page do
  @moduledoc false

  use Wallaby.DSL

  import Wallaby.Query, only: [css: 1]

  def flash_info do
    css("[data-test='flash_info']")
  end
end
