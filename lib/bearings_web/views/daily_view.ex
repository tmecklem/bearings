defmodule BearingsWeb.DailyView do
  use BearingsWeb, :view

  alias Timex.Interval
  alias Bearings.Dailies.Daily

  def calendar(dailies) do
    case dailies_range(dailies) do
      nil ->
        []

      {start_date, end_date} ->
        Interval.new(
          from: start_date |> Timex.beginning_of_week(:sun),
          until: end_date |> Timex.end_of_week(:sun),
          right_open: false
        )
        |> Enum.map(fn day -> add_dailies_for_day(day, dailies) end)
    end
  end

  defp add_dailies_for_day(day, dailies) do
    {day, Enum.filter(dailies, fn daily -> Date.to_erl(daily.date) == Date.to_erl(day) end)}
  end

  defp dailies_range(nil), do: nil
  defp dailies_range([]), do: nil

  defp dailies_range(dailies) do
    dailies
    |> Enum.reduce(nil, fn
      daily, nil ->
        {daily.date, daily.date}

      daily, {start_date, end_date} ->
        {Enum.min_by([start_date, daily.date], &Date.to_erl/1),
         Enum.max_by([end_date, daily.date], &Date.to_erl/1)}
    end)

  def render_goal_fields(%Daily{} = daily) do
    form = Daily.changeset(daily, %{}) |> Phoenix.HTML.FormData.to_form([])

    render_to_string(__MODULE__, "goal_fields.html", daily_form: form)
  end
end
