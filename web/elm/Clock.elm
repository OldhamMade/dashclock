module ClockApp exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import String exposing (join, toInt, pad)
import Date exposing (year, hour, minute, second, fromTime)
import Time exposing (Time)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


dateDisplay : Time -> Html Msg
dateDisplay t =
    let
        date_ =
            fromTime t

        day_ =
            if Date.day date_ > 9 then
                toString (Date.day date_)
            else
                " " ++ toString (Date.day date_)

        month_ =
            toString (Date.month date_)

        year_ =
            toString (Date.year date_)
    in
        -- join sep [(pad 2 '0' hours'), (pad 2 '0' minutes')]
        div []
            [ div [ id "month" ] [ text month_ ]
            , div [ id "day" ] [ text day_ ]
              -- , div [ id "year" ] [ text year' ]
            ]


timeDisplay : Time -> Html Msg
timeDisplay t =
    let
        date_ =
            fromTime t

        hours_ =
            toString (Date.hour date_)

        minutes_ =
            toString (Date.minute date_)

        seconds_ =
            Date.second date_

        sep =
            if seconds_ % 2 == 0 then
                "active"
            else
                "hidden"
    in
        -- join sep [(pad 2 '0' hours'), (pad 2 '0' minutes')]
        div []
            [ div [ id "fg" ]
                [ div [ id "hours" ] [ text (pad 2 '0' hours_) ]
                , div [ id "sep", class sep ] [ text "." ]
                , div [ id "minutes" ] [ text (pad 2 '0' minutes_) ]
                ]
            , div [ id "bg" ]
                [ div [ class "hours" ] [ text "88" ]
                , div [ class "minute" ] [ text "88" ]
                ]
            ]



-- MODEL


type alias Model =
    Time


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( newTime, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick



-- VIEW


view : Model -> Html Msg
view t =
    div []
        [ div [ id "date" ]
            [ (t
                |> dateDisplay
              )
            ]
        , div [ id "clock" ]
            [ (t
                |> timeDisplay
              )
            ]
        ]
