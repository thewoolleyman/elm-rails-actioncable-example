module View exposing (page)

import Types exposing (Msg(..), Model)
import Channels.View exposing (channelStatusRow)
import Domain.View exposing (domainStateRow)
import Domain.Commands.View exposing (commandHistoryPane)
import Domain.Events.View exposing (eventHistoryPane)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


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
        [ commandHistoryPane model.domainCommandHistory
        , eventHistoryPane model.domainEventHistory
        ]
