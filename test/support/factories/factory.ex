defmodule Bearings.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Bearings.Repo

  use Bearings.DailyFactory
  use Bearings.SupporterFactory
  use Bearings.UserFactory
end
