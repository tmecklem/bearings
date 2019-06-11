defmodule BearingsWeb.Page do
  @moduledoc false

  use Hound.Helpers

  import ExUnit.Assertions

  def flash_info do
    find_element(:css, "[data-test='flash_info']")
  end

  def login(user) do
    navigate_to("/")
    click({:css, "[data-test='login']"})
    assert visible_text({:css, "[data-test='current_user']"}) == user.name
  end
end
