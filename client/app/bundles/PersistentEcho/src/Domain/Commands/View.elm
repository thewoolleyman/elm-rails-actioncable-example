module Domain.Commands.View exposing (commandHistoryPane)

import Types exposing (Msg(..))
import Domain.Commands.Types exposing (DomainCommand, DomainCommandHistory)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)


commandHistoryPane : DomainCommandHistory -> Html Msg
commandHistoryPane domainCommandHistory =
    div [ historyPaneStyle ]
        [ div [ historyItemRowStyle ]
            [ text "Domain Commands Sent History:" ]
        , commandHistoryRows domainCommandHistory
        ]


commandHistoryRows : List DomainCommand -> Html Msg
commandHistoryRows domainCommands =
    div [ historyItemRowStyle ]
        (map (\domainCommand -> div [] [ text <| toString domainCommand ]) domainCommands)
