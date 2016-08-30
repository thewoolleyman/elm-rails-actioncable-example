module PersistentEcho.App exposing (main)

import PersistentEcho.Ports as Ports
import PersistentEcho.State as State
import PersistentEcho.View as View
import Html.App

main : Program Never
main =
    Html.App.program
        { init =
            ( State.initialModel
            , State.initialCommands
            )
        , view = View.root
        , update = State.update
        , subscriptions = Ports.subscriptions
        }
