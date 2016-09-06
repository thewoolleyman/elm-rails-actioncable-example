module PersistentEcho.View exposing (page)

import PersistentEcho.Types exposing (..)
import PersistentEcho.Utils.Reverser exposing (reverseIt)
import PersistentEcho.Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import List exposing (map)


page : Model -> Html Msg
page model =
    div [ pageStyle ]
        [ headerRow model
        , domainStateRow model
        , historyRow model
        , clientStatusRow model
        ]


headerRow : Model -> Html Msg
headerRow model =
    div [ headerRowStyle ]
        [ span [] [ text "Elm, Rails, ActionCable, Command Query Responsibility Segregation, Event Sourcing" ] ]


domainStateRow : Model -> Html Msg
domainStateRow model =
    div [ domainStateRowStyle ]
        [ textualPane model
        , numericPane model
        ]


textualPane : Model -> Html Msg
textualPane model =
    div [ textualPaneStyle ]
        [ div []
            [ text "Textual State:" ]
        , div []
            [ span [] [ text "Send the text down: " ]
            , input [ placeholder "type some text", value model.domainState.text, onInput InvokeUpdateText ] []
            ]
        , div []
            [ span [] [ text "Flip it and reverse it: " ]
            , span []
                [ a [ href "https://youtu.be/UODX_pYpVxk", target "_" ] [ text (reverseIt model.domainState.text) ]
                ]
            ]
        ]


numericPane : Model -> Html Msg
numericPane model =
    div [ numericPaneStyle ]
        [ div []
            [ text "Numeric State:" ]
        , div []
            [ span [] [ text "The number is currently: " ]
            , span [] [ text (toString model.domainState.integer) ]
            ]
        , div []
            [ button [ onClick (InvokeUpdateNumber model.domainState.integer) ] [ text "Increment" ]
            ]
        ]


historyRow : Model -> Html Msg
historyRow model =
    div [ historyRowStyle ]
        [ commandHistoryPane model
        , eventHistoryPane model
        ]


commandHistoryPane : Model -> Html Msg
commandHistoryPane model =
    div [ historyPaneStyle ]
        [ div []
            [ text "Domain Commands Sent History:" ]
        , commandHistoryRows model.domainCommandHistory
        ]


commandHistoryRows : List DomainCommand -> Html Msg
commandHistoryRows domainCommands =
    div []
        (map (\domainCommand -> div [] [ text <| toString domainCommand ]) domainCommands)


eventHistoryPane : Model -> Html Msg
eventHistoryPane model =
    div [ historyPaneStyle ]
        [ div []
            [ text "Domain Events Received History:" ]
        , eventHistoryRows model.domainEventHistory
        ]


eventHistoryRows : List DomainEvent -> Html Msg
eventHistoryRows domainEvents =
    div []
        (map (\domainEvent -> div [] [ text <| toString domainEvent ]) domainEvents)


clientStatusRow : Model -> Html Msg
clientStatusRow model =
    div [ clientStatusRowStyle ]
        [ div []
            [ span []
                [ text "Websocket Command Channel Status: "
                , text model.commandChannelStatus
                ]
            ]
        , div []
            [ span []
                [ text "Websocket Event Channel Status: "
                , text model.eventChannelStatus
                ]
            ]
        , div []
            [ span []
                [ text "Last Websocket Command Channel Connection.send Successful: "
                , text (toString model.commandConnectionSendResult)
                ]
            ]
        , div []
            [ span []
                [ text "Last Websocket Command Channel Invocation Result: "
                , text (toString model.commandInvocationResult)
                ]
            ]
        , div []
            [ span []
                [ text "Last Websocket Event Channel Connection.send Successful: "
                , text (toString model.eventConnectionSendResult)
                ]
            ]
        ]
