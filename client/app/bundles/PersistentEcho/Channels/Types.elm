module PersistentEcho.Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectedStatuses
        , CommandConnectionSendResult
        , CommandInvocationResult
        , EventConnectionSendResult
        )

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


type alias CommandConnectionSendResult =
    Bool


type alias CommandInvocationResult =
    { result : String
    , details : List String
    }


type alias EventConnectionSendResult =
    Bool
