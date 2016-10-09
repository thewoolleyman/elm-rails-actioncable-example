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

import Domain.Types exposing (TextualEntity, NumericEntity)


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
    = TextualEntityUpdatedEventData TextualEntity
    | NumericEntityUpdatedEventData NumericEntity
    | Invalid String


invalidDomainEvent : String -> DomainEvent
invalidDomainEvent errorMessage =
    { eventId = ""
    , sequence = -1
    , data = Invalid errorMessage
    }



{-
   TODO: Why can't this use the parameter style of creating a record, e.g.: eventData = TextualEntity entityId integer
-}


textualEntityUpdatedEventData : String -> String -> EventData
textualEntityUpdatedEventData entityId text =
    let
        eventData =
            { entityId = entityId, text = text }
    in
        TextualEntityUpdatedEventData eventData


numericEntityUpdatedEventData : String -> Int -> EventData
numericEntityUpdatedEventData entityId integer =
    let
        eventData =
            { entityId = entityId, integer = integer }
    in
        NumericEntityUpdatedEventData eventData
