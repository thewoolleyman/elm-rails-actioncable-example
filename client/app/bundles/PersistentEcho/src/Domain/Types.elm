module Domain.Types
    exposing
        ( DomainState
        , Entity
        , TextualEntity
        , NumericEntity
        )

{-
   client's copy of server domain state

   In a real app, you might remove the redundant word "Domain" in "DomainCommand" since it's already
   under the Domain.Commands namespace, but it's left explicit in this example app, to make it
   clear that this type has nothing to do with the standard Elm "Cmd" type.
-}


type alias DomainState =
    { textualEntities : List TextualEntity
    , numericEntities : List NumericEntity
    }


type alias Entity a =
    { a | entityId : String }


type alias TextualEntity =
    Entity
        { text : String
        }


type alias NumericEntity =
    Entity
        { integer : Int
        }
