defmodule Dashclock.PageControllerTest do
  use Dashclock.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "DashClock"
  end
end
