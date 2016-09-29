module Domain.Commands.UpdateText exposing (updateText)

import Types exposing (Msg(..))
import Domain.Commands.Types
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
