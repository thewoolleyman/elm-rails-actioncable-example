port module PersistentEcho.Ports exposing (..)

import PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        , ChannelConnectedStatus
        , CommandConnectionSendResult
        , CommandInvocationResult
        , EventConnectionSendResult
        )
import PersistentEcho.Domain.Events.Types exposing (Sequence)
import Json.Encode exposing (Value)


port receiveChannelConnectedStatus : (ChannelConnectedStatus -> msg) -> Sub msg


port invokeCommandOnServer : Value -> Cmd msg


port receiveCommandConnectionSendResult : (CommandConnectionSendResult -> msg) -> Sub msg


port receiveCommandInvocationResult : (CommandInvocationResult -> msg) -> Sub msg


port receiveEventConnectionSendResult : (EventConnectionSendResult -> msg) -> Sub msg


port getEventsSince : { data : Sequence } -> Cmd msg


port applyEvents : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveChannelConnectedStatus ReceiveChannelConnectedStatus
        , receiveCommandConnectionSendResult ReceiveCommandConnectionSendResult
        , receiveCommandInvocationResult ReceiveCommandInvocationResult
        , receiveEventConnectionSendResult ReceiveEventConnectionSendResult
        , applyEvents ApplyEvents
        ]
