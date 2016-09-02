module PersistentEcho.View exposing (root)

import PersistentEcho.Types exposing (..)
import PersistentEcho.Utils.Reverser exposing (reverseIt)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

root : Model -> Html Msg
root model =
  div []
    [
      div [] [
        span [] [
          text "Channel Status: "
        , text model.channelStatus
        ]
      ]
    , div [] [
        span [] [ text "Send the state down: " ]
      , input [ placeholder "type model state", value model.state, onInput Publish ] []
      ]
    , div [] [
        span [] [ text "Flip it and reverse it: " ]
      , span [] [
          a [ href "https://youtu.be/UODX_pYpVxk", target "_" ] [
            text (reverseIt model.state)
          ]
        ]
      ]
    ]
