defmodule Bearings.Dailies do
  @moduledoc """
  The Dailies context.
  """

  import Ecto.Query, warn: false
  alias Bearings.Repo

  alias Bearings.Account.User
  alias Bearings.Dailies.{Daily, Goal}

  @doc """
  Returns the adjacent daily ids for the given user
  """
  def get_adjacent(owner_id: owner_id, date: date) do
    before_daily =
      Repo.one(
        from(
          d in Daily,
          where: d.owner_id == ^owner_id and d.date < ^date,
          preload: [goals: ^preload_goals()],
          order_by: [desc: d.date],
          limit: 1
        )
      )

    after_daily =
      Repo.one(
        from(
          d in Daily,
          where: d.owner_id == ^owner_id and d.date > ^date,
          preload: [goals: ^preload_goals()],
          order_by: [asc: d.date],
          limit: 1
        )
      )

    {before_daily, after_daily}
  end

  @doc """
  Returns the list of dailies for the user and anyone the user supports.

  ## Examples

  iex> list_dailies(username)
  [%Daily{}, ...]

  """
  def list_dailies(%User{id: user_id}, options \\ []) do
    include_supports = Keyword.get(options, :include_supports, false)
    days = Keyword.get(options, :days, 3650)

    user_ids =
      case include_supports do
        true ->
          user =
            User
            |> where([u], u.id == ^user_id)
            |> preload(:supports_users)
            |> Repo.one()

          [user | user.supports_users]
          |> Enum.map(& &1.id)

        false ->
          [user_id]
      end

    earliest_date = Timex.shift(Date.utc_today, days: (-1 * days))

    Daily
    |> join(:inner, [d], o in assoc(d, :owner))
    |> where([_d, o], o.id in ^user_ids)
    |> where([d], d.date >= ^earliest_date)
    |> preload([d], [:owner])
    |> order_by(:date)
    |> Repo.all()
    |> Repo.preload(goals: from(g in Goal, order_by: g.index))
  end

  @doc """
  Gets a single daily.
  """
  def get_daily!(date, username) do
    Repo.one!(
      from(
        d in Daily,
        join: o in User,
        on: o.id == d.owner_id,
        where: d.date == ^date,
        where: o.username == ^username,
        order_by: :date,
        preload: [goals: ^preload_goals()]
      )
    )
  end

  defp preload_goals do
    from(g in Goal, order_by: g.index)
  end

  @doc """
  Gets a single Goal
  """
  def get_goal!(id) do
    Goal
    |> Repo.get(id)
    |> Repo.preload([:daily])
  end

  @doc """
  Creates a daily.

  ## Examples

      iex> create_daily(%{field: value})
      {:ok, %Daily{}}

      iex> create_daily(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily(attrs \\ %{}) do
    %Daily{}
    |> Daily.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a daily.

  ## Examples

      iex> update_daily(daily, %{field: new_value})
      {:ok, %Daily{}}

      iex> update_daily(daily, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily(%Daily{} = daily, attrs) do
    daily
    |> Daily.changeset(attrs)
    |> Repo.update()
  end

  def update_goals(%Daily{} = daily, attrs) do
    daily
    |> Daily.goals_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Daily.

  ## Examples

      iex> delete_daily(daily)
      {:ok, %Daily{}}

      iex> delete_daily(daily)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily(%Daily{} = daily) do
    Repo.delete(daily)
  end

  @doc """
  Deletes a Goal.

  ## Examples

      iex> delete_goal(goal)
      {:ok, %Goal{}}

      iex> delete_goal(goal)
      {:error, %Ecto.Changeset{}}
  """
  def delete_goal(%Goal{} = goal) do
    Repo.delete(goal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily changes.

  ## Examples

      iex> change_daily(daily)
      %Ecto.Changeset{source: %Daily{}}

  """
  def change_daily(%Daily{} = daily) do
    Daily.changeset(daily, %{})
  end

  alias Bearings.Dailies.Template

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    Repo.all(Template)
  end

  @doc """
  Gets a single template.

  Returns nil if the Template does not exist.
  """
  def get_template(%User{id: id}) do
    Template
    |> where([t], t.owner_id == ^id)
    |> Repo.one()
  end

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{source: %Template{}}

  """
  def change_template(%Template{} = template) do
    Template.changeset(template, %{})
  end
end
