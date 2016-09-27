port module PersistentEcho.Ports
    exposing
        ( receiveChannelConnectedStatus
        , invokeCommandOnServer
        , logChannelConnectionSendFailure
        , receiveCommandInvocationResult
        , getEventsSince
        , applyEvents
        , subscriptions
        )

import PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        )
import PersistentEcho.Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectionSendFailure
        , CommandInvocationResult
        )
import PersistentEcho.Domain.Events.Types exposing (Sequence)
import Json.Encode exposing (Value)


port receiveChannelConnectedStatus : (ChannelConnectedStatus -> msg) -> Sub msg


port invokeCommandOnServer : Value -> Cmd msg


port logChannelConnectionSendFailure : (ChannelConnectionSendFailure -> msg) -> Sub msg


port receiveCommandInvocationResult : (CommandInvocationResult -> msg) -> Sub msg


port getEventsSince : { data : Sequence } -> Cmd msg


port applyEvents : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveChannelConnectedStatus ReceiveChannelConnectedStatus
        , logChannelConnectionSendFailure LogChannelConnectionSendFailure
        , receiveCommandInvocationResult ReceiveCommandInvocationResult
        , applyEvents ApplyEvents
        ]
