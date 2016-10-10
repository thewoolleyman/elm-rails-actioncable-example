module Domain.Commands.UpdateNumericEntity exposing (updateNumericEntity)

import Domain.Commands.Types exposing (DomainCommand(..))


updateNumericEntity : Int -> DomainCommand
updateNumericEntity newInteger =
    UpdateNumericEntityCommand
        { name = "UpdateNumericEntity"
        , data = { integer = newInteger + 1 }
        }
