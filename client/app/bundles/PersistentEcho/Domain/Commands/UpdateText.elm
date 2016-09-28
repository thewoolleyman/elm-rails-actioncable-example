module PersistentEcho.Domain.Commands.UpdateText exposing (updateText)

import PersistentEcho.Types exposing (Msg(..))
import PersistentEcho.Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommand(..)
        )


updateText : String -> Msg
updateText newText =
    InvokeDomainCommand <|
        UpdateTextCommand
            { name = "UpdateText"
            , data = { text = newText }
            }
