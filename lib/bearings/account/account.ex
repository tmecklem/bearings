defmodule Bearings.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Bearings.Repo

  alias Bearings.Account.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def find_or_create_from_github(github_user) do
    User
    |> where(github_id: ^github_user.github_id)
    |> Repo.one()
    |> case do
      nil -> create_user(github_user)
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Bearings.Account.Alliance

  @doc """
  Returns the list of supporters.

  ## Examples

      iex> list_supporters()
      [Alliance{}, ...]

  """
  def list_supporter_alliances(%User{} = user) do
    Repo.all(
      from s in Alliance,
      where: s.user_id == ^user.id,
      join: supporter in assoc(s, :supporter),
      preload: [:supporter, :user],
      order_by: supporter.username
    )
  end

  @doc """
  Gets a single alliance.

  Raises `Ecto.NoResultsError` if the Alliance does not exist.

  ## Examples

      iex> get_alliance!(123)
      %Alliance{}

      iex> get_alliance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alliance!(id), do: Repo.get!(Alliance, id)

  def find_alliance(supporter: %User{id: supporter_id}, owner_username: owner_username) do
    Alliance
    |> join(:inner, [s], u in assoc(s, :user))
    |> where([s, u], s.supporter_id == ^supporter_id and u.username == ^owner_username)
    |> preload([s], [:user])
    |> Repo.one()
  end

  @doc """
  Creates an alliance.

  ## Examples

      iex> create_alliance(%{field: value})
      {:ok, %Alliance{}}

      iex> create_alliance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alliance(attrs \\ %{}) do
    %Alliance{}
    |> Alliance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an alliance.

  ## Examples

      iex> update_alliance(alliance, %{field: new_value})
      {:ok, %Alliance{}}

      iex> update_alliance(alliance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alliance(%Alliance{} = alliance, attrs) do
    alliance
    |> Alliance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Alliance.

  ## Examples

      iex> delete_alliance(alliance)
      {:ok, %Alliance{}}

      iex> delete_alliance(alliance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alliance(%Alliance{} = alliance) do
    Repo.delete(alliance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alliance changes.

  ## Examples

      iex> change_alliance(alliance)
      %Ecto.Changeset{source: %Alliance{}}

  """
  def change_alliance(%Alliance{} = alliance) do
    Alliance.changeset(alliance, %{})
  end
end
