module Domain.Events.Types
    exposing
        ( DomainEvent
        , Sequence
        , DomainEventHistory
        , EventData(..)
        , invalidDomainEvent
        , textualEntityUpdatedEventData
        , numericEntityUpdatedEventData
        )


type alias DomainEventHistory =
    List DomainEvent



{-
   In a real app, you might remove the redundant word "Domain" in "DomainEvent" since it's already
   under the Domain.Events namespace, but it's left explicit in this example app, to make it
   clear that this corresponds to the "DomainCommand" type in the CQRS/ES architecture.
-}


type alias DomainEvent =
    { eventId : Id
    , sequence : Sequence
    , data : EventData
    }


type alias Id =
    String


type alias Sequence =
    Int


type EventData
    = TextualEntityUpdated TextualEntityUpdatedEventData
    | NumericEntityUpdated NumericEntityUpdatedEventData
    | Invalid String


type alias TextualEntityUpdatedEventData =
    { entityId : String
    , text : String
    }


type alias NumericEntityUpdatedEventData =
    { entityId : String
    , integer : Int
    }


invalidDomainEvent : String -> DomainEvent
invalidDomainEvent errorMessage =
    { eventId = ""
    , sequence = -1
    , data = Invalid errorMessage
    }


textualEntityUpdatedEventData : String -> String -> EventData
textualEntityUpdatedEventData entityId text =
    let
        eventData =
            TextualEntityUpdatedEventData entityId text
    in
        TextualEntityUpdated eventData


numericEntityUpdatedEventData : String -> Int -> EventData
numericEntityUpdatedEventData entityId integer =
    let
        eventData =
            NumericEntityUpdatedEventData entityId integer
    in
        NumericEntityUpdated eventData
