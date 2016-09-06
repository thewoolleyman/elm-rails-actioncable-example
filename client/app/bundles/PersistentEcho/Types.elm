module PersistentEcho.Types exposing (..)

-- TODO: only expose needed types
-- TODO: split domain-related types and logic out to namespace, and maybe command/event sub-namespaces

import Json.Encode exposing (Value)


-- Msg are in "chronological" order, in which they would occur for a command/event loop involving only one client


type Msg
    = ReceiveCommandChannelStatus CommandChannelStatus
    | ReceiveEventChannelStatus EventChannelStatus
    | InvokeUpdateText String
    | InvokeUpdateNumber Int
    | ReceiveCommandConnectionSendResult CommandConnectionSendResult
    | ReceiveCommandInvocationResult CommandInvocationResult
    | ReceiveEventConnectionSendResult EventConnectionSendResult
    | ApplyEvents Value



-- top-level model


type alias Model =
    { commandChannelStatus : CommandChannelStatus
    , eventChannelStatus : EventChannelStatus
    , commandConnectionSendResult : CommandConnectionSendResult
    , commandInvocationResult : CommandInvocationResult
    , eventConnectionSendResult : EventConnectionSendResult
    , domainCommandHistory : List DomainCommand
    , domainEventHistory : DomainEventHistory
    , domainState : DomainState
    }



-- client local websocket status and metrics


type alias CommandChannelStatus =
    String


type alias EventChannelStatus =
    String


type alias CommandConnectionSendResult =
    Bool


type alias CommandInvocationResult =
    { result : String
    , details : List String
    }


type alias EventConnectionSendResult =
    Bool



-- client's copy of server state


type alias DomainState =
    { text : String
    , integer : Int
    }



-- Domain commands and events
-- NOTE: PortedDomainCommand uses an *extensible record* definition to avoid having to be explicit about the
--       type of the data field.


type alias PortedDomainCommand =
    Json.Encode.Value


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


type alias DomainEvent =
    { id : Id
    , sequence : Sequence
    , data : EventData
    }


type alias DomainEventHistory =
    List DomainEvent


type alias Id =
    String


type alias Sequence =
    Int


nullDomainEvent : DomainEvent
nullDomainEvent =
    { id = ""
    , sequence = -1
    , data = Null
    }


invalidDomainEvent : String -> DomainEvent
invalidDomainEvent errorMessage =
    { id = ""
    , sequence = -1
    , data = Invalid errorMessage
    }


type EventData
    = TextualEntityUpdated String
    | NumericEntityUpdated Int
    | Null
    | Invalid String



-- Follow http://package.elm-lang.org/help/design-guidelines#keep-tags-and-record-constructors-secret


type alias TextualEntityUpdatedEventData =
    { text : String }


type alias NumericEntityUpdatedEventData =
    { integer : Int }


textualEntityUpdatedEventData : String -> EventData
textualEntityUpdatedEventData text =
    TextualEntityUpdated text


numericEntityUpdatedEventData : Int -> EventData
numericEntityUpdatedEventData integer =
    NumericEntityUpdated integer
