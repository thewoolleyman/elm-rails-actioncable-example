module PersistentEcho.View exposing (page)

import PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        )
import PersistentEcho.Channels.View exposing (channelStatusRow)
import PersistentEcho.Domain.Commands.Types exposing (DomainCommand)
import PersistentEcho.Domain.Commands.UpdateText exposing (updateText)
import PersistentEcho.Domain.Commands.UpdateNumber exposing (updateNumber)
import PersistentEcho.Domain.Events.Types exposing (DomainEvent)
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
        , channelStatusRow model
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
            [ text "Textual Entity State:" ]
        , div []
            [ span [] [ text "Send the text down: " ]
            , input [ placeholder "type some text", value model.domainState.text, onInput updateText ] []
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
            [ text "Numeric Entity State:" ]
        , div []
            [ span [] [ text "The number is currently: " ]
            , span [] [ text (toString model.domainState.integer) ]
            ]
        , div []
            [ button [ onClick (InvokeDomainCommand <| updateNumber model.domainState.integer) ] [ text "Increment" ]
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
