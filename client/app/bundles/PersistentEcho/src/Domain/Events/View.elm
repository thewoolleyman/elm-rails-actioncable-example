module Domain.Events.View exposing (eventHistoryPane)

import Types exposing (Msg(..))
import Domain.Events.Types exposing (DomainEvent, DomainEventHistory)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)


eventHistoryPane : DomainEventHistory -> Html Msg
eventHistoryPane domainEventHistory =
    div [ historyPaneStyle ]
        [ div []
            [ text "Domain Events Received History:" ]
        , eventHistoryRows domainEventHistory
        ]


eventHistoryRows : List DomainEvent -> Html Msg
eventHistoryRows domainEvents =
    div []
        (map (\domainEvent -> div [] [ text <| toString domainEvent ]) domainEvents)
