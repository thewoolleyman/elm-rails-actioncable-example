module PersistentEcho.Domain.Commands.UpdateText exposing (updateText)

import PersistentEcho.Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommand(..)
        )


updateText : String -> DomainCommand
updateText newText =
    UpdateTextCommand
        { name = "UpdateText"
        , data = { text = newText }
        }
