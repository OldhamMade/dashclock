defmodule Dashclock.Facts.TFL do
  def get() do
    response = HTTPotion.get(url, [timeout: 100_000])
    Poison.decode!(response.body)
  end

  defp settings() do
    File.cwd! <> "/settings.yaml"
  end

  defp url() do
    [ document | _ ] = :yamerl_constr.file(settings)
    
    url = :proplists.get_value(
      'TFL',
      :proplists.get_value(
        'APICalls',
        document
      )
    )
    |> to_string

    apiid = :proplists.get_value(
      'id', 
      :proplists.get_value(
        'TFL',
        :proplists.get_value(
          'APIKeys',
          document
        )
      )
    )
    |> to_string

    apikey = :proplists.get_value(
      'key', 
      :proplists.get_value(
        'TFL',
        :proplists.get_value(
          'APIKeys',
          document
        )
      )
    )
    |> to_string

    url
    |> String.replace("{id}", apiid)
    |> String.replace("{key}", apikey)

  end
end
