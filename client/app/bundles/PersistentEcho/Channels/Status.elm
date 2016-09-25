module PersistentEcho.Channels.Status
    exposing
        ( initialChannelConnectedStatuses
        , updateChannelConnectedStatus
        )

import PersistentEcho.Ports exposing (getEventsSince)
import PersistentEcho.Channels.Types
    exposing
        ( ChannelConnectedStatus
        , ChannelConnectedStatuses
        )
import PersistentEcho.Domain.Events.Types exposing (Sequence)


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

        -- Don't attempt to get initial events until the channel is open.
        "EventsSinceChannel" ->
            ( { channelConnectedStatuses | eventsSinceChannel = channelConnectedStatus.connected }
            , getEventsSince { data = latestDomainEventSequence }
            )

        _ ->
            Debug.crash "Invalid channel name received for updating channel connected status."
