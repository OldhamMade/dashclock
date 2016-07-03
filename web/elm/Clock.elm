module ClockApp exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import String exposing (join, toInt, pad)
import Date exposing (year, hour, minute, second, fromTime)
import Time exposing (Time)


main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


dateDisplay : Time -> Html Msg
dateDisplay t =
  let date' = fromTime t
      day' =
          if Date.day date' > 9 then
              toString (Date.day date')
          else
              "\x00a0" ++ toString (Date.day date')
      month' = toString (Date.month date')
      year' = toString (Date.year date')
  in
      -- join sep [(pad 2 '0' hours'), (pad 2 '0' minutes')]
      div [ ] [ div [ id "month" ] [ text month' ]
              , div [ id "day" ] [ text day' ]
              , div [ id "year" ] [ text year' ]
              ]


timeDisplay : Time -> Html Msg
timeDisplay t =
  let date' = fromTime t
      hours' = toString (Date.hour date')
      minutes' = toString (Date.minute date')
      seconds' = Date.second date'
      sep = if seconds' % 2 == 0 then "active" else "hidden"
  in
      -- join sep [(pad 2 '0' hours'), (pad 2 '0' minutes')]
    div [ ] [
           div [ id "fg" ] [ div [ id "hours" ] [ text (pad 2 '0' hours') ]
                           , div [ id "sep", class sep ] [ text "." ]
                           , div [ id "minutes" ] [ text (pad 2 '0' minutes') ]
                           ],
           div [ id "bg" ] [ div [ class "hours" ] [ text "88" ]
                           , div [ class "minute" ] [ text "88" ]
                           ]
          ]


-- MODEL

type alias Model = Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


-- UPDATE

type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every Time.second Tick


-- VIEW

view : Model -> Html Msg
view t =
  div [] [
         div [ id "date" ]
           [ ( t
             |> dateDisplay
             )
           ]
       , div [ id "clock" ]
           [ ( t
             |> timeDisplay
             )
           ]
        ]
