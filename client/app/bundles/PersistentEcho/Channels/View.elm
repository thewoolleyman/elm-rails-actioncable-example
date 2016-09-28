module PersistentEcho.Channels.View exposing (channelStatusRow)

import PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        )
import PersistentEcho.Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


channelStatusRow : Model -> Html Msg
channelStatusRow model =
    div [ channelStatusRowStyle ]
        [ div []
            [ span []
                [ text "Websocket Channel Connected Statuses: "
                , text <| toString model.channelConnectedStatuses
                ]
            ]
        , div []
            [ span []
                [ text "Websocket Command Channel Connection.send Failures: "
                , text (toString model.channelConnectionSendFailures)
                ]
            ]
        , div []
            [ span []
                [ text "Last Websocket Command Channel Invocation Result: "
                , text (toString model.commandInvocationResult)
                ]
            ]
        ]
