module Domain.Commands.UpdateTextualEntity exposing (updateTextualEntity)

import Types exposing (Msg(..))
import Domain.Commands.Types exposing (DomainCommand(..))


updateTextualEntity : String -> String -> Msg
updateTextualEntity entityId newText =
    InvokeDomainCommand <|
        UpdateTextualEntityCommand
            { name = "UpdateTextualEntity"
            , data =
                { entityId = entityId
                , text = newText
                }
            }
