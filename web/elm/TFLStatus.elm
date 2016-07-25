module TFLStatusApp exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Http
import Task
import Time exposing (Time)
import Json.Decode exposing (..)
import FontAwesome.Web as Icon


main =
  Html.App.program
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


loading = { state = "loading",
            lines = "Loading..." }
    
init : (Model, Cmd Msg)
init =
  ( loading
  , getLineStatus
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
        , getLineStatus
        )

    FetchSucceed status ->
        ( status
        , Cmd.none
        )
          
    FetchFailed _ ->
        ( loading
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
      div [ ]
          [ displayState data ]


-- HTTP

getLineStatus : Cmd Msg
getLineStatus =
  let
    url = "/api/tfl"
  in
    Task.perform FetchFailed FetchSucceed (Http.get resultDecoder url)

resultDecoder : Decoder Model
resultDecoder =
    object2 Model
      ("state" := string)
      ("lines" := string)

