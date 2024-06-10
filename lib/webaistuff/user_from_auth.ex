defmodule Webaistuff.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Jason
  alias Webaistuff.Accounts
  alias Ueberauth.Auth

  def find_or_create(auth, provider) do
    case Accounts.get_user_by_provider(provider, auth.uid) do
      nil -> create_user(auth, provider)
      user -> {:ok, user}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warning("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp basic_info(auth, provider) do
    %{name: name_from_auth(auth), avatar_url: avatar_from_auth(auth), email: email_from_auth(auth), provider: provider, provider_uid: to_string(auth.uid)}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  defp email_from_auth(%Auth{info: %{email: email}}), do: email


  defp create_user(%Auth{} = auth, provider) do
    user = Accounts.register_user(basic_info(auth, provider), [validate_provider: true, validate_password: false])

    case user do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, "Failed to create user: #{inspect(changeset)}"}
    end
  end

end
