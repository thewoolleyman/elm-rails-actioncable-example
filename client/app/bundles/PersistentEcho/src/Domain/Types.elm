module Domain.Types
    exposing
        ( DomainState
        )

{-
   client's copy of server domain state

   In a real app, you might remove the redundant word "Domain" in "DomainCommand" since it's already
   under the Domain.Commands namespace, but it's left explicit in this example app, to make it
   clear that this type has nothing to do with the standard Elm "Cmd" type.
-}


type alias DomainState =
    { text : String
    , integer : Int
    }
