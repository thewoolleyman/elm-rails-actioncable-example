module State
    exposing
        ( initialModel
        , initialCmds
        , update
        )

import Ports
    exposing
        ( receiveChannelConnectedStatus
        , invokeCommandOnServer
        , logChannelConnectionSendFailure
        , receiveCommandInvocationResult
        )
import Types exposing (Msg(..), Model)
import Channels.ConnectionSendFailures
    exposing
        ( initialChannelConnectionSendFailures
        )
import Channels.Status
    exposing
        ( initialChannelConnectedStatuses
        , updateChannelConnectedStatus
        )
import Domain.State exposing (initialDomainState)
import Domain.Commands.Processor exposing (invokeCommand)
import Domain.Events.Processor
    exposing
        ( applyDomainEvents
        , latestDomainEventSequence
        )
import Domain.Events.Decoder exposing (decodeDomainEventsFromPort)


-- See https://gist.github.com/evancz/2b2ba366cae1887fe621 for state architecture guidelines


initialModel : Model
initialModel =
    { channelConnectedStatuses = initialChannelConnectedStatuses
    , channelConnectionSendFailures = initialChannelConnectionSendFailures
    , commandInvocationResult = Nothing
    , domainCommandHistory = []
    , domainEventHistory = []
    , domainState = initialDomainState
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch
        [ Cmd.none
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InvokeDomainCommand domainCommand ->
            invokeCommand domainCommand model

        ReceiveChannelConnectedStatus channelConnectedStatus ->
            let
                ( newChannelConnectedStatuses, cmd ) =
                    updateChannelConnectedStatus
                        channelConnectedStatus
                        (latestDomainEventSequence model.domainEventHistory)
                        model.channelConnectedStatuses
            in
                ( { model | channelConnectedStatuses = newChannelConnectedStatuses }, cmd )

        LogChannelConnectionSendFailure channelConnectionSendFailure ->
            let
                newChannelConnectionSendFailures =
                    channelConnectionSendFailure :: model.channelConnectionSendFailures
            in
                ( { model | channelConnectionSendFailures = newChannelConnectionSendFailures }, Cmd.none )

        ReceiveCommandInvocationResult newCommandInvocationResult ->
            ( { model | commandInvocationResult = Just newCommandInvocationResult }, Cmd.none )

        ApplyEvents domainEventsValueFromPort ->
            let
                domainEvents =
                    decodeDomainEventsFromPort domainEventsValueFromPort

                ( newDomainState, newDomainEventHistory ) =
                    applyDomainEvents domainEvents model.domainState model.domainEventHistory
            in
                ( { model | domainState = newDomainState, domainEventHistory = newDomainEventHistory }, Cmd.none )
