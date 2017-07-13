defmodule Dashclock.TFLController do
  use Dashclock.Web, :controller

  # Based on severity list here:
  # https://api.tfl.gov.uk/Line/Meta/Severity
  # I'm happy with "Minor Delays" showing as "ok"
  @severity_ok [9, 10, 18, 19]

  def status(conn, _params) do
    data = Dashclock.TFL.get()

    result = problem_lines(data)
    |> Enum.sort
    |> Enum.join(", ")

    case result do
      "" -> json(conn, %{state: "ok", lines: "Good Service"})
      _ -> json(conn, %{state: "problems", lines: result})
    end
  end

  def problem_lines(data) do
    data
    |> Enum.map(fn(i) -> line_state(i) end)
    |> Enum.reject(&(&1 == nil))
  end

  def line_state(line) do
    unless hd(line["lineStatuses"])["statusSeverity"] in @severity_ok do
      line["name"]
    end
  end
end
