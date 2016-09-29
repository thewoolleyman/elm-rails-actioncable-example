module Channels.Status
    exposing
        ( initialChannelConnectedStatuses
        , updateChannelConnectedStatus
        )

import Ports exposing (getEventsSince)
import Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectedStatuses
        )
import Domain.Events.Types exposing (Sequence)


initialChannelConnectedStatuses : ChannelConnectedStatuses
initialChannelConnectedStatuses =
    { commandChannel = False
    , eventChannel = False
    , eventsSinceChannel = False
    }


updateChannelConnectedStatus : ChannelConnectedStatus -> Sequence -> ChannelConnectedStatuses -> ( ChannelConnectedStatuses, Cmd msg )
updateChannelConnectedStatus channelConnectedStatus latestDomainEventSequence channelConnectedStatuses =
    case channelConnectedStatus.channel of
        "CommandChannel" ->
            ( { channelConnectedStatuses | commandChannel = channelConnectedStatus.connected }, Cmd.none )

        "EventChannel" ->
            ( { channelConnectedStatuses | eventChannel = channelConnectedStatus.connected }, Cmd.none )

        "EventsSinceChannel" ->
            let
                cmd =
                    -- Don't attempt to get events unless the channel is open.
                    if channelConnectedStatus.connected == True then
                        getEventsSince { data = latestDomainEventSequence }
                    else
                        Cmd.none
            in
                ( { channelConnectedStatuses | eventsSinceChannel = channelConnectedStatus.connected }, cmd )

        _ ->
            Debug.crash "Invalid channel name received for updating channel connected status."
