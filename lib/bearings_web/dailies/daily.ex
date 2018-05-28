defimpl Phoenix.Param, for: Bearings.Dailies.Daily do
  alias Bearings.Dailies.Daily

  def to_param(%Daily{date: date}) do
    Timex.format!(date, "{YYYY}-{M}-{D}")
  end
end
