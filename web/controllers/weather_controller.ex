defmodule Dashclock.WeatherController do
  use Dashclock.Web, :controller
  use Timex

  @map_keys ~w(
    icon
    date time datetime
    temperature temperatureMin temperatureMax
    precipProbability precipType
  )

  @empty %{
    "icon" => "",
    "date" => "",
    "time" => 0,
    "datetime" => "",
    "temperature" => 0,
    "temperatureMin" => 0,
    "temperatureMax" => 0,
    "precipProbability" => 0,
    "precipType" => "",
  }

  def overview(conn, _params) do
    weather = Dashclock.Weather.get()
    |> forecast
    
    json(conn, weather)
  end

  def forecast(data) do
    [Map.merge(Enum.at(data["daily"]["data"], 1), data["currently"])] ++
      Enum.slice(data["daily"]["data"], 2, 2)
    |> Enum.map(&trim_keys/1)
    |> Enum.map(&add_keys/1)
    |> Enum.map(&add_datetime/1)
    |> Enum.map(&round_temps/1)
    |> Enum.map(&fix_probabilities/1)
  end

  def from_timestamp(timestamp, format \\ "{ISO:Extended}") do
    Timex.from_unix(timestamp, :seconds)
    |> Timex.format!(format)
  end

  def add_datetime(item) do
    item
    |> Map.put("date", from_timestamp(item["time"], "{YYYY}-{0M}-{0D}"))
    |> Map.put("datetime", from_timestamp(item["time"]))
  end

  def trim_keys(item) do
    Map.take(item, @map_keys)
  end

  def add_keys(item) do
    Map.merge(@empty, item)
  end

  def round_temps(item) do
    item
    |> Map.put("temperature", round(item["temperature"]))
    |> Map.put("temperatureMin", round(item["temperatureMin"]))
    |> Map.put("temperatureMax", round(item["temperatureMax"]))
  end

  def fix_probabilities(item) do
    item
    |> Map.put("precipProbability", round(item["precipProbability"] * 100))
  end
end
