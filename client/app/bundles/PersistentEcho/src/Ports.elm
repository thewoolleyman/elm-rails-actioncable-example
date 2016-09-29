port module Ports
    exposing
        ( receiveChannelConnectedStatus
        , getEventsSince
        , invokeCommandOnServer
        , logChannelConnectionSendFailure
        , receiveCommandInvocationResult
        , applyEvents
        , subscriptions
        )

import Types
    exposing
        ( Msg(..)
        , Model
        )
import Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectionSendFailure
        , CommandInvocationResult
        )
import Domain.Events.Types exposing (Sequence)
import Json.Encode exposing (Value)


port receiveChannelConnectedStatus : (ChannelConnectedStatus -> msg) -> Sub msg


port getEventsSince : { data : Sequence } -> Cmd msg


port invokeCommandOnServer : Value -> Cmd msg


port logChannelConnectionSendFailure : (ChannelConnectionSendFailure -> msg) -> Sub msg


port receiveCommandInvocationResult : (CommandInvocationResult -> msg) -> Sub msg


port applyEvents : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveChannelConnectedStatus ReceiveChannelConnectedStatus
        , logChannelConnectionSendFailure LogChannelConnectionSendFailure
        , receiveCommandInvocationResult ReceiveCommandInvocationResult
        , applyEvents ApplyEvents
        ]
