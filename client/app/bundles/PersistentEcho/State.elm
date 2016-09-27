module PersistentEcho.State
    exposing
        ( initialModel
        , initialCmds
        , update
        )

import PersistentEcho.Ports
    exposing
        ( receiveChannelConnectedStatus
        , invokeCommandOnServer
        , logChannelConnectionSendFailure
        , receiveCommandInvocationResult
        )
import PersistentEcho.Channels.ConnectionSendFailures
    exposing
        ( initialChannelConnectionSendFailures
        )
import PersistentEcho.Channels.Status
    exposing
        ( initialChannelConnectedStatuses
        , updateChannelConnectedStatus
        )
import PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        , DomainState
        )
import PersistentEcho.Domain.Commands.Processor
    exposing
        ( portedDomainCommand
        , logDomainCommandToHistory
        )
import PersistentEcho.Domain.Commands.UpdateText exposing (updateText)
import PersistentEcho.Domain.Commands.UpdateNumber exposing (updateNumber)
import PersistentEcho.Domain.Events.Processor
    exposing
        ( decodeDomainEventsFromPort
        , processEvent
        , applyDomainEvents
        , latestDomainEventSequence
        )


-- See https://gist.github.com/evancz/2b2ba366cae1887fe621 for state architecture guidelines


initialModel : Model
initialModel =
    { channelConnectedStatuses = initialChannelConnectedStatuses
    , channelConnectionSendFailures = initialChannelConnectionSendFailures
    , commandInvocationResult =
        { result = "uninitialized"
        , details = []
        }
    , domainCommandHistory = []
    , domainEventHistory = []
    , domainState = initialDomainState
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch
        [ Cmd.none
        ]


initialDomainState : DomainState
initialDomainState =
    { text = ""
    , integer = 0
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InvokeUpdateText newText ->
            let
                updateTextCommand =
                    updateText newText

                newModel =
                    logDomainCommandToHistory updateTextCommand model
            in
                ( newModel, invokeCommandOnServer (portedDomainCommand updateTextCommand) )

        InvokeUpdateNumber newNumber ->
            let
                updateNumberCommand =
                    updateNumber newNumber

                newModel =
                    logDomainCommandToHistory updateNumberCommand model
            in
                ( newModel, invokeCommandOnServer (portedDomainCommand updateNumberCommand) )

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
            ( { model | commandInvocationResult = newCommandInvocationResult }, Cmd.none )

        ApplyEvents domainEventsValueFromPort ->
            let
                domainEvents =
                    decodeDomainEventsFromPort domainEventsValueFromPort

                ( newDomainState, newDomainEventHistory ) =
                    applyDomainEvents domainEvents model.domainState model.domainEventHistory
            in
                ( { model | domainState = newDomainState, domainEventHistory = newDomainEventHistory }, Cmd.none )
