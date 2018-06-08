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
  def get_adjacent(%Daily{} = daily) do
    before_daily =
      Repo.one(
        from(
          d in Daily,
          where: d.owner_id == ^daily.owner_id and d.date < ^daily.date,
          preload: [:goals],
          order_by: [desc: d.date],
          limit: 1
        )
      )

    after_daily =
      Repo.one(
        from(
          d in Daily,
          where: d.owner_id == ^daily.owner_id and d.date > ^daily.date,
          preload: [:goals],
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

    Daily
    |> join(:inner, [d], o in assoc(d, :owner))
    |> where([_d, o], o.id in ^user_ids)
    |> preload([d], [:owner])
    |> order_by(:date)
    |> Repo.all()
    |> Repo.preload(goals: from(g in Goal, order_by: g.index))
  end

  @doc """
  Gets a single daily.
  """
  def get_daily!(date, username) do
    Daily
    |> join(:inner, [d], o in User, o.id == d.owner_id)
    |> where([d], d.date == ^date)
    |> where([_d, o], o.username == ^username)
    |> order_by(:date)
    |> Repo.one!()
    |> Repo.preload(goals: from(g in Goal, order_by: g.index))
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
end
