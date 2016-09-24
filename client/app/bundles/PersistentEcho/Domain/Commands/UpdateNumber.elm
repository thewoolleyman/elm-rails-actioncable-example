module PersistentEcho.Domain.Commands.UpdateNumber exposing (..)

import PersistentEcho.Types exposing (..)


updateNumber : Int -> DomainCommand
updateNumber newInteger =
    UpdateNumberCommand
        { name = "UpdateNumber"
        , data = { integer = newInteger + 1 }
        }
