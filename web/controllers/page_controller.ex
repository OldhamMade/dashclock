defmodule Dashclock.PageController do
  use Dashclock.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
