module PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        , CommandChannelStatus
        , EventChannelStatus
        , CommandConnectionSendResult
        , CommandInvocationResult
        , EventConnectionSendResult
        , DomainState
        )

import PersistentEcho.Domain.Commands.Types exposing (DomainCommand)
import PersistentEcho.Domain.Commands.Types exposing (DomainCommandHistory)
import PersistentEcho.Domain.Events.Types exposing (DomainEventHistory)
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
    , domainCommandHistory : DomainCommandHistory
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



-- client's copy of server domain state


type alias DomainState =
    { text : String
    , integer : Int
    }
