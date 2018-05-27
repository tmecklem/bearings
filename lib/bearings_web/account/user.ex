defimpl Phoenix.Param, for: Bearings.Account.User do
  def to_param(%{github_login: username}) do
    username
  end
end
