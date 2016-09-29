module App exposing (main)

import Ports exposing (subscriptions)
import State exposing (initialModel, initialCmds, update)
import View exposing (page)
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
