module Types
    exposing
        ( Msg(..)
        , Model
        , DomainState
        )

import Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectedStatuses
        , ChannelConnectionSendFailure
        , ChannelConnectionSendFailures
        , CommandInvocationResult
        )
import Domain.Commands.Types exposing (DomainCommand, DomainCommandHistory)
import Domain.Events.Types exposing (DomainEventHistory)
import Json.Encode exposing (Value)


-- Msg are in "chronological" order, in which they would occur for a command/event loop involving only one client


type Msg
    = ReceiveChannelConnectedStatus ChannelConnectedStatus
    | InvokeDomainCommand DomainCommand
    | LogChannelConnectionSendFailure ChannelConnectionSendFailure
    | ReceiveCommandInvocationResult CommandInvocationResult
    | ApplyEvents Value



-- top-level model


type alias Model =
    { channelConnectedStatuses : ChannelConnectedStatuses
    , channelConnectionSendFailures : ChannelConnectionSendFailures
    , commandInvocationResult : Maybe CommandInvocationResult
    , domainCommandHistory : DomainCommandHistory
    , domainEventHistory : DomainEventHistory
    , domainState : DomainState
    }



-- client's copy of server domain state


type alias DomainState =
    { text : String
    , integer : Int
    }
