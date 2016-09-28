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
        [ channelConnectedRow model.channelConnectedStatuses
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


channelConnectedRow channelConnectedStatuses =
    div []
        [ div [ channelConnectedRowStyle ]
            [ span [] [ text "Websocket Channel Connected: " ]
            , span [ statusStyle channelConnectedStatuses.commandChannel ] [ text "commandChannel" ]
            , span [ statusStyle channelConnectedStatuses.eventChannel ] [ text "eventChannel" ]
            , span [ statusStyle channelConnectedStatuses.eventsSinceChannel ] [ text "eventsSinceChannel" ]
            ]
        ]


statusStyle : Bool -> Attribute msg
statusStyle bool =
    if bool then
        greenBackgroundStyle
    else
        redBackgroundStyle
