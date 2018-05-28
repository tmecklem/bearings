defimpl Phoenix.Param, for: Bearings.Account.User do
  def to_param(%{username: username}) do
    username
  end
end
