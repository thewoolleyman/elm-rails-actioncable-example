module PersistentEcho.App exposing (main)

import PersistentEcho.Ports exposing (subscriptions)
import PersistentEcho.State exposing (initialModel, initialCmds, update)
import PersistentEcho.View exposing (page)
import Html.App


main : Program Never
main =
    Html.App.program
        { init =
            ( initialModel
            , initialCmds
            )
        , view = page
        , update = update
        , subscriptions = subscriptions
        }
