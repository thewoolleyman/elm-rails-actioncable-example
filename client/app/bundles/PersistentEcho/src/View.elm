module View exposing (page)

import Types
    exposing
        ( Msg(..)
        , Model
        )
import Channels.View exposing (channelStatusRow)
import Domain.Commands.Types exposing (DomainCommand)
import Domain.Commands.UpdateText exposing (updateText)
import Domain.Commands.UpdateNumber exposing (updateNumber)
import Domain.Types exposing (DomainState, TextualEntity, NumericEntity)
import Domain.Events.Types exposing (DomainEvent)
import Utils.Reverser exposing (reverseIt)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import List exposing (head, map)


page : Model -> Html Msg
page model =
    div [ pageStyle ]
        [ headerRow model
        , domainStateRow model.domainState
        , historyRow model
        , channelStatusRow model
        ]


headerRow : Model -> Html Msg
headerRow model =
    div [ headerRowStyle ]
        [ span []
            [ a [ href "https://github.com/thewoolleyman/elm-rails-actioncable-example", target "_" ]
                [ text "Elm, Rails, ActionCable, Command Query Responsibility Segregation, Event Sourcing" ]
            ]
        ]



-- TODO: Move to Domain.View module


domainStateRow : DomainState -> Html Msg
domainStateRow domainState =
    let
        textualEntity =
            head domainState.textualEntities

        textualPaneContent =
            case textualEntity of
                Just entity ->
                    textualPane entity

                Nothing ->
                    div [ textualPaneStyle ] [ text "No Textual Entities" ]

        numericEntity =
            head domainState.numericEntities

        numericPaneContent =
            case numericEntity of
                Just entity ->
                    numericPane entity

                Nothing ->
                    div [ numericPaneStyle ] [ text "No Numeric Entities" ]
    in
        div [ domainStateRowStyle ]
            [ textualPaneContent
            , numericPaneContent
            ]


textualPane : TextualEntity -> Html Msg
textualPane textualEntity =
    div [ textualPaneStyle ]
        [ div []
            [ text "Textual Entity State:" ]
        , div []
            [ span [] [ text "Send the text down: " ]
            , input [ placeholder "type some text", value textualEntity.text, onInput updateText ] []
            ]
        , div []
            [ span [] [ text "Flip it and reverse it: " ]
            , span []
                [ a [ href "https://youtu.be/UODX_pYpVxk", target "_" ] [ text (reverseIt textualEntity.text) ]
                ]
            ]
        ]


numericPane : NumericEntity -> Html Msg
numericPane numericEntity =
    div [ numericPaneStyle ]
        [ div []
            [ text "Numeric Entity State:" ]
        , div []
            [ span [] [ text "The number is currently: " ]
            , span [] [ text (toString numericEntity.integer) ]
            ]
        , div []
            [ button [ onClick (InvokeDomainCommand <| updateNumber numericEntity.integer) ] [ text "Increment" ]
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
