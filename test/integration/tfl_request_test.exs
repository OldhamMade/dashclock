defmodule TFLRequestIntegrationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test 'we can get a basic json response from the tfl website' do
    response = conn(:get, "/api/tfl")
    assert response.status == 200
  end
end
