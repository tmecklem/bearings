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

  alias Bearings.Account.Supporter

  @doc """
  Returns the list of supporters.

  ## Examples

      iex> list_supporters()
      [%Supporter{}, ...]

  """
  def list_supporters do
    Repo.all(Supporter)
  end

  @doc """
  Gets a single supporter.

  Raises `Ecto.NoResultsError` if the Supporter does not exist.

  ## Examples

      iex> get_supporter!(123)
      %Supporter{}

      iex> get_supporter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_supporter!(id), do: Repo.get!(Supporter, id)

  def find_supporter(supporter: %User{id: supporter_id}, owner_username: owner_username) do
    Supporter
    |> join(:inner, [s], u in assoc(s, :user))
    |> where([s, u], s.supporter_id == ^supporter_id and u.username == ^owner_username)
    |> Repo.one()
  end

  @doc """
  Creates a supporter.

  ## Examples

      iex> create_supporter(%{field: value})
      {:ok, %Supporter{}}

      iex> create_supporter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_supporter(attrs \\ %{}) do
    %Supporter{}
    |> Supporter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a supporter.

  ## Examples

      iex> update_supporter(supporter, %{field: new_value})
      {:ok, %Supporter{}}

      iex> update_supporter(supporter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_supporter(%Supporter{} = supporter, attrs) do
    supporter
    |> Supporter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Supporter.

  ## Examples

      iex> delete_supporter(supporter)
      {:ok, %Supporter{}}

      iex> delete_supporter(supporter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_supporter(%Supporter{} = supporter) do
    Repo.delete(supporter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking supporter changes.

  ## Examples

      iex> change_supporter(supporter)
      %Ecto.Changeset{source: %Supporter{}}

  """
  def change_supporter(%Supporter{} = supporter) do
    Supporter.changeset(supporter, %{})
  end
end
