defmodule Bearings.Dailies do
  @moduledoc """
  The Dailies context.
  """

  import Ecto.Query, warn: false
  alias Bearings.Repo

  alias Bearings.Account.User
  alias Bearings.Dailies.Daily

  @doc """
  Returns the list of dailies.

  ## Examples

      iex> list_dailies()
      [%Daily{}, ...]

  """
  def list_dailies(username) do
    Daily
    |> join(:inner, [d], o in User, o.id == d.owner_id)
    |> where([_d, o], o.username == ^username)
    |> order_by(:date)
    |> Repo.all()
  end

  @doc """
  Gets a single daily.
  """
  def get_daily!(date, username) do
    Daily
    |> join(:inner, [d], o in User, o.id == d.owner_id)
    |> where([d], d.date == ^date)
    |> where([_d, o], o.username == ^username)
    |> Repo.one!()
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
  Returns an `%Ecto.Changeset{}` for tracking daily changes.

  ## Examples

      iex> change_daily(daily)
      %Ecto.Changeset{source: %Daily{}}

  """
  def change_daily(%Daily{} = daily) do
    Daily.changeset(daily, %{})
  end
end
