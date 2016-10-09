module View exposing (page)

import Types
    exposing
        ( Msg(..)
        , Model
        )
import Channels.View exposing (channelStatusRow)
import Domain.View exposing (domainStateRow)
import Domain.Types exposing (DomainState, TextualEntity, NumericEntity)
import Domain.Commands.Types exposing (DomainCommand)
import Domain.Events.Types exposing (DomainEvent)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)


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
