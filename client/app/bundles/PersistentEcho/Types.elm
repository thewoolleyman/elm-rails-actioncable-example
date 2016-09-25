module PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        , DomainState
        )

import PersistentEcho.Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectedStatuses
        , CommandConnectionSendResult
        , CommandInvocationResult
        , EventConnectionSendResult
        )
import PersistentEcho.Domain.Commands.Types exposing (DomainCommand, DomainCommandHistory)
import PersistentEcho.Domain.Events.Types exposing (DomainEventHistory)
import Json.Encode exposing (Value)


-- Msg are in "chronological" order, in which they would occur for a command/event loop involving only one client


type Msg
    = ReceiveChannelConnectedStatus ChannelConnectedStatus
    | InvokeUpdateText String
    | InvokeUpdateNumber Int
    | ReceiveCommandConnectionSendResult CommandConnectionSendResult
    | ReceiveCommandInvocationResult CommandInvocationResult
    | ReceiveEventConnectionSendResult EventConnectionSendResult
    | ApplyEvents Value



-- top-level model


type alias Model =
    { channelConnectedStatuses : ChannelConnectedStatuses
    , commandConnectionSendResult : CommandConnectionSendResult
    , commandInvocationResult : CommandInvocationResult
    , eventConnectionSendResult : EventConnectionSendResult
    , domainCommandHistory : DomainCommandHistory
    , domainEventHistory : DomainEventHistory
    , domainState : DomainState
    }



-- client's copy of server domain state


type alias DomainState =
    { text : String
    , integer : Int
    }
