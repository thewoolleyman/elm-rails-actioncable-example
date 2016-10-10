module Domain.Commands.UpdateNumericEntity exposing (updateNumericEntity)

import Types exposing (Msg(..))
import Domain.Commands.Types exposing (DomainCommand(..))


updateNumericEntity : Int -> Msg
updateNumericEntity newInteger =
    InvokeDomainCommand <|
        UpdateNumericEntityCommand
            { name = "UpdateNumericEntity"
            , data = { integer = newInteger + 1 }
            }
