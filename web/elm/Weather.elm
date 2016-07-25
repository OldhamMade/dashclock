module WeatherApp exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy)
import Html.App
import Http
import Task
import Time exposing (Time)
import Json.Decode exposing (int, string, float, (:=))
import Json.Decode.Pipeline as Pipeline

main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Day =
    { time : Int
    , temperatureMin : Int
    , temperatureMax : Int
    , temperature : Int
    , precipType : String
    , precipProbability : Int
    , icon : String
    , datetime : String
    , date : String
    , error : String
    }

type alias Model =
    List Day


init : (Model, Cmd Msg)
init =
  ( []
  , getWeather
  )


-- UPDATE

type Msg
  = Request Time
  | FetchSucceed Model
  | FetchFailed Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Request _ ->
        ( model
        , getWeather
        )

    FetchSucceed results ->
        ( results
        , Cmd.none
        )

    FetchFailed error ->
        ( []
        , Cmd.none
        )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every (Time.minute * 5) Request


-- VIEW

view : Model -> Html Msg
view model =
    div [ ]
        (List.indexedMap dayView model)


dayView : Int -> Day -> Html Msg
dayView pos data =
    div [ id ("day-" ++ (toString pos))
        , class "day"
        ]
        [ iconView data
        , tempView data
        , precipView data
        ]


iconView: Day -> Html Msg
iconView data =
    i [ class ("icon wi wi-fw wi-forecast-io-" ++ data.icon) ]
      [ ]


tempView: Day -> Html Msg
tempView data =
    div [ class "temperatures" ]
        [ currentTempView data
        , minTempView data
        , maxTempView data
        ]


currentTempView: Day -> Html Msg
currentTempView data =
    div [ class "temp-current" ]
        [ text <| toString <| data.temperature ]


minTempView: Day -> Html Msg
minTempView data =
    div [ class "temp-min" ]
        [ text <| toString <| data.temperatureMin ]


maxTempView: Day -> Html Msg
maxTempView data =
    div [ class "temp-max" ]
        [ text <| toString <| data.temperatureMax ]


precipIcon : String -> Html Msg
precipIcon text =
    case text of
        "snow" ->
            i [ class "wi wi-fw wi-snow" ] []
        "sleet" ->
            i [ class "wi wi-fw wi-sleet" ] []
        true ->
            i [ class "wi wi-fw wi-raindrop" ] []


precipView : Day -> Html Msg
precipView data =
    div [ class "precip" ]
        [ precipIcon data.precipType
        , text ((toString data.precipProbability) ++ "%")
        ]


-- HTTP

getWeather : Cmd Msg
getWeather =
  let
    url = "/api/weather"
  in
    Task.perform FetchFailed FetchSucceed (Http.get decodeWeather url)

decodeWeather : Json.Decode.Decoder (List Day)
decodeWeather =
    Json.Decode.list dayDecoder

dayDecoder : Json.Decode.Decoder Day
dayDecoder =
  Pipeline.decode Day
    |> Pipeline.required "time" int
    |> Pipeline.required "temperatureMin" int
    |> Pipeline.required "temperatureMax" int
    |> Pipeline.required "temperature" int
    |> Pipeline.required "precipType" string
    |> Pipeline.required "precipProbability" int
    |> Pipeline.required "icon" string
    |> Pipeline.required "datetime" string
    |> Pipeline.required "date" string
    |> Pipeline.optional "error" string ""
