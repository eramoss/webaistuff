defmodule WebaistuffWeb.OAuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use WebaistuffWeb, :controller

  plug Ueberauth

  alias WebaistuffWeb.UserAuth
  alias Webaistuff.UserFromAuth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth, to_string(auth.provider)) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> UserAuth.log_in_user(user)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
