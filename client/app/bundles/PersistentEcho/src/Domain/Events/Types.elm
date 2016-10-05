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
    = TextualEntityUpdated String
    | NumericEntityUpdated Int
    | Invalid String


type alias TextualEntityUpdatedEventData =
    { text : String }


type alias NumericEntityUpdatedEventData =
    { integer : Int }


invalidDomainEvent : String -> DomainEvent
invalidDomainEvent errorMessage =
    { eventId = ""
    , sequence = -1
    , data = Invalid errorMessage
    }


textualEntityUpdatedEventData : String -> EventData
textualEntityUpdatedEventData text =
    TextualEntityUpdated text


numericEntityUpdatedEventData : Int -> EventData
numericEntityUpdatedEventData integer =
    NumericEntityUpdated integer
