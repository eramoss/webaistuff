defmodule WebaistuffWeb.PageController do
  use WebaistuffWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def app(conn, _params) do
    render(conn, :app, layout: {WebaistuffWeb.Layouts, "app"})
  end
end
