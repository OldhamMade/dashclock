module TFLStatusApp exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import Http
import Task
import Time exposing (Time)
import Json.Decode exposing (..)
import FontAwesome.Web as Icon


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { state : String
    , lines : String
    }


loading =
    { state = "loading"
    , lines = "Loading..."
    }


init : ( Model, Cmd Msg )
init =
    ( loading
    , getLineStatus
    )



-- UPDATE


type Msg
    = Request Time
    | FetchResponse (Result Http.Error Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Request _ ->
            ( model
            , getLineStatus
            )

        FetchResponse (Err _) ->
            ( loading
            , Cmd.none
            )

        FetchResponse (Ok status) ->
            ( status
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second * 30) Request



-- VIEW


view : Model -> Html Msg
view data =
    let
        displayState data =
            case data.state of
                "loading" ->
                    div [ class data.state ] [ Icon.clock_o, text (data.lines) ]

                "problems" ->
                    div [ class data.state ] [ Icon.exclamation_circle, text (data.lines) ]

                "ok" ->
                    div [ class data.state ] [ Icon.check_circle, text (data.lines) ]

                true ->
                    div [ class "unknown" ] [ Icon.question_circle, text "Something went wrong" ]
    in
        div []
            [ displayState data ]



-- HTTP


getLineStatus : Cmd Msg
getLineStatus =
    Http.get "/api/tfl" resultDecoder
        |> Http.send FetchResponse


resultDecoder : Decoder Model
resultDecoder =
    map2 Model
        (field "state" string)
        (field "lines" string)
