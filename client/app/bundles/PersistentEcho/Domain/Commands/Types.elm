module PersistentEcho.Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommandHistory
        , DomainCommand(..)
        )

import Json.Encode exposing (Value)


type alias PortedDomainCommand =
    Value


type alias DomainCommandHistory =
    List DomainCommand



{- In a real app, you might remove the redundant word "Domain" in "DomainCommand" since it's already
   under the Domain.Commands namespace, but it's left explicit in this example app, to make it
   clear that this type has nothing to do with the standard Elm "Cmd" type.
-}


type DomainCommand
    = UpdateTextCommand UpdateText
    | UpdateNumberCommand UpdateNumber


type alias UpdateText =
    { name : String
    , data : { text : String }
    }


type alias UpdateNumber =
    { name : String
    , data : { integer : Int }
    }
