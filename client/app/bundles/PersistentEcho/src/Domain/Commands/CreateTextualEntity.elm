module Domain.Commands.CreateTextualEntity exposing (createTextualEntity)

import Types exposing (Msg(..))
import Domain.Commands.Types exposing (DomainCommand(..))


createTextualEntity : Msg
createTextualEntity =
    InvokeDomainCommand <|
        CreateTextualEntityCommand { name = "CreateTextualEntity" }
