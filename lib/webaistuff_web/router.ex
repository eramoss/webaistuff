defmodule WebaistuffWeb.Router do
  use WebaistuffWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WebaistuffWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :ensure_authenticated do
    plug WebaistuffWeb.Plugs.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebaistuffWeb do
    pipe_through :browser
    get "/", PageController, :home
  end

  scope "/app", WebaistuffWeb do
    pipe_through [:browser, :ensure_authenticated]
    get "/", PageController, :home
  end

  scope "/login", WebaistuffWeb do
    pipe_through :browser
    get "/", PageController, :login
    post "/", PageController, :login
  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:webaistuff, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WebaistuffWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
