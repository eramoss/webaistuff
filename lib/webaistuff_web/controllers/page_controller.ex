defmodule WebaistuffWeb.PageController do
  use WebaistuffWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def login(conn, _params) do
    render(conn, :login, layout: false, page_title: "Login")
  end

  def app(conn, _params) do
    render(conn, :app, layout: {WebaistuffWeb.Layouts, "app"})
  end
end
