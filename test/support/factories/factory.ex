defmodule Bearings.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Bearings.Repo

  use Bearings.DailyFactory
  use Bearings.GoalFactory
  use Bearings.SupporterFactory
  use Bearings.TemplateFactory
  use Bearings.UserFactory
end
