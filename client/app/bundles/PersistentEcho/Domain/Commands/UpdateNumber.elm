module PersistentEcho.Domain.Commands.UpdateNumber exposing (updateNumber)

import PersistentEcho.Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommand(..)
        )


updateNumber : Int -> DomainCommand
updateNumber newInteger =
    UpdateNumberCommand
        { name = "UpdateNumber"
        , data = { integer = newInteger + 1 }
        }
