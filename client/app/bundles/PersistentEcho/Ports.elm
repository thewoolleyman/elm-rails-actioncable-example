port module PersistentEcho.Ports exposing (..)

import PersistentEcho.Types exposing (..)
import Json.Encode exposing (Value)


port receiveCommandChannelStatus : (CommandChannelStatus -> msg) -> Sub msg


port receiveEventChannelStatus : (EventChannelStatus -> msg) -> Sub msg


port invokeCommandOnServer : Value -> Cmd msg


port receiveCommandConnectionSendResult : (CommandConnectionSendResult -> msg) -> Sub msg


port receiveCommandInvocationResult : (CommandInvocationResult -> msg) -> Sub msg


port receiveEventConnectionSendResult : (EventConnectionSendResult -> msg) -> Sub msg


port getEventsSince : { data : Sequence } -> Cmd msg


port applyEvents : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveEventChannelStatus ReceiveEventChannelStatus
        , receiveCommandChannelStatus ReceiveCommandChannelStatus
        , receiveCommandConnectionSendResult ReceiveCommandConnectionSendResult
        , receiveCommandInvocationResult ReceiveCommandInvocationResult
        , receiveEventConnectionSendResult ReceiveEventConnectionSendResult
        , applyEvents ApplyEvents
        ]
