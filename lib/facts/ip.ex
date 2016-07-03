defmodule Dashclock.Facts.IP do
  def get() do
    response = HTTPotion.get(url, [timeout: 50_000])
    response.body
  end

  defp settings() do
    File.cwd! <> "/settings.yaml"
  end

  defp url() do
    [ document | _ ] = :yamerl_constr.file(settings)
    :proplists.get_value(
      'IP',
      :proplists.get_value(
        'APICalls',
        document
      )
    )
  end
end
