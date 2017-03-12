module SensorDataApp exposing (..)

import Html exposing (Html, div, text)
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


type alias Model =
    { temp_c: Float
    , temp_f: Float
    , humidity_pc: Float
    }


type Msg
    = Request Time
    | FetchResponse (Result Http.Error (Model))


loading =
    { temp_c = 0.0
    , temp_f = 0.0
    , humidity_pc = 0.0
    }


init : ( Model, Cmd Msg )
init =
    ( loading
    , getModel
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Request _ ->
            ( model
            , getModel
            )

        FetchResponse (Err _) ->
            ( loading
            , Cmd.none
            )

        FetchResponse (Ok results) ->
            ( results
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second * 15) Request


view : Model -> Html Msg
view model =
    div [ id "sensor-data" ]
        [ tempView model
        , humidityView model
        ]


tempView : Model -> Html Msg
tempView data =
    div [ id "indoor-temp" ]
        [ text ("/" ++ (toString <| round <| data.temp_c)) ]


humidityView : Model -> Html Msg
humidityView data =
    div [ id "indoor-humidity" ]
        [ text (( toString <| round <| data.humidity_pc) ++ "%") ]


getModel =
    Http.get "/api/temp" decodeModel
        |> Http.send FetchResponse


decodeModel : Json.Decode.Decoder Model
decodeModel =
    Pipeline.decode Model
        |> Pipeline.required "temp_c" float
        |> Pipeline.required "temp_f" float
        |> Pipeline.required "humidity_pc" float
