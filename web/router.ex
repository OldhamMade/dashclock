defmodule Dashclock.Router do
  use Dashclock.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dashclock do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Dashclock do
    pipe_through :api

    get "/tfl", TFLController, :status

    get "/weather", WeatherController, :overview

    get "/temp", TempController, :data

    get "/sensors", SerieslyController, :latest
  end
end
