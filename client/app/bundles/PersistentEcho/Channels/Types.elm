module PersistentEcho.Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectedStatuses
        , ChannelConnectionSendFailure
        , ChannelConnectionSendFailures
        , CommandInvocationResult
        )

import Json.Encode exposing (Value)


-- client local websocket status and metrics


type alias ChannelConnectedStatus =
    { channel : String
    , connected : Bool
    }


type alias ChannelConnectedStatuses =
    { commandChannel : Bool
    , eventChannel : Bool
    , eventsSinceChannel : Bool
    }


type alias ChannelConnectionSendFailures =
    List ChannelConnectionSendFailure


type alias ChannelConnectionSendFailure =
    { channelName : String
    , action : String
    , data : Value
    }


type alias CommandInvocationResult =
    { result : String
    , details : List String
    }
