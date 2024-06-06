defmodule WebaistuffWeb.Plugs.EnsureAuthenticated do
  use WebaistuffWeb, :verified_routes
  import Plug.Conn
  import Phoenix.Controller

  def init(_opts), do: nil

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access this page")
        |> redirect(to: ~p"/login")
      _ ->
        conn
    end
  end
end
