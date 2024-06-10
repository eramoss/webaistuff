defmodule Webaistuff.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Jason
  alias Webaistuff.Accounts
  alias Ueberauth.Auth

  def find_or_create(auth) do
    case Accounts.get_user_by_provider(provider_from_auth(auth), provider_uid_from_auth(auth)) do
      nil -> create_user(auth)
      user -> {:ok, user}
    end
  end



  defp basic_info(auth) do
    %{name: name_from_auth(auth), avatar_url: avatar_from_auth(auth), email: email_from_auth(auth), provider: provider_from_auth(auth), provider_uid: provider_uid_from_auth(auth)}
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

  defp email_from_auth(auth) do
    Logger.warning("#{auth.provider} needs to find an email!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp provider_from_auth(%Auth{provider: provider}), do: to_string(provider)

  defp provider_uid_from_auth(%Auth{uid: uid}), do: to_string(uid)

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

  defp create_user(%Auth{} = auth) do
    user = Accounts.register_user(basic_info(auth), [validate_provider: true, validate_password: false])

    case user do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, "Failed to create user: #{inspect(changeset)}"}
    end
  end

end
