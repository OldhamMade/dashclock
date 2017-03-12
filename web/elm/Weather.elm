module WeatherApp exposing (..)

import Html exposing (Html, div, i, span, text)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy)
import Http
import Task
import Time exposing (Time)
import Json.Decode exposing (..)
import Json.Decode.Pipeline as Pipeline


main =
    Html.program
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


init : ( Model, Cmd Msg )
init =
    ( []
    , getWeather
    )



-- UPDATE


type Msg
    = Request Time
    | FetchResponse (Result Http.Error (List Day))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Request _ ->
            ( model
            , getWeather
            )

        FetchResponse (Err _) ->
            ( []
            , Cmd.none
            )

        FetchResponse (Ok results) ->
            ( results
            , Cmd.none
            )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.minute * 5) Request


-- VIEW


view : Model -> Html Msg
view model =
    div []
        (List.indexedMap dayView model)


dayView : Int -> Day -> Html Msg
dayView pos data =
    div
        [ id ("day-" ++ (toString pos))
        , class "day"
        ]
        [ iconView data
        , tempView data
        , precipView data
        ]


iconView : Day -> Html Msg
iconView data =
    i [ class ("icon wi wi-fw wi-forecast-io-" ++ data.icon) ]
        []


tempView : Day -> Html Msg
tempView data =
    div [ class "temperatures" ]
        [ currentTempView data
        , maxTempView data
        , span [ class "sep" ] [ text "·" ]
        , minTempView data
        ]


currentTempView : Day -> Html Msg
currentTempView data =
    div [ class "temp-current" ]
        [ text <| toString <| data.temperature ]


minTempView : Day -> Html Msg
minTempView data =
    div [ class "temp-min" ]
        [ text <| toString <| data.temperatureMin ]


maxTempView : Day -> Html Msg
maxTempView data =
    div [ class "temp-max" ]
        [ text <| toString <| data.temperatureMax ]


precipIconName : String -> String
precipIconName text =
    case text of
        "snow" -> "snow"
        "sleet" -> "sleet"
        true -> "raindrop"


precipIcon : String -> String -> Html Msg
precipIcon text pc =
    let
        iconName = precipIconName text
    in
        div []
            [ i [ class ("wi wi-fw wi-" ++ iconName) ] []
            , div [ class "precip-bar" ]
                [ div [ class "precip-percent"
                      , style [("width", pc ++ "%")]]
                      []
                ]
            ]


precipView : Day -> Html Msg
precipView data =
    div [ class "precip" ]
        [ precipIcon data.precipType (toString data.precipProbability)
        -- , text ((toString data.precipProbability) ++ "%")
        ]



-- HTTP


-- getWeather : Task x Msg
getWeather =
    Http.get "/api/weather" decodeWeather
        |> Http.send FetchResponse

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
