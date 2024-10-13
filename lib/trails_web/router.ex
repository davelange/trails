defmodule TrailsWeb.Router do
  use TrailsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TrailsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrailsWeb do
    pipe_through :browser

    live "/", CursorTracker
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrailsWeb do
  #   pipe_through :api
  # end
end
