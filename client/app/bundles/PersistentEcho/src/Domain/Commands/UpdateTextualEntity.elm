module Domain.Commands.UpdateTextualEntity exposing (updateTextualEntity)

import Types exposing (Msg(..))
import Domain.Commands.Types exposing (DomainCommand(..))


updateTextualEntity : String -> Msg
updateTextualEntity newText =
    InvokeDomainCommand <|
        UpdateTextualEntityCommand
            { name = "UpdateTextualEntity"
            , data = { text = newText }
            }
