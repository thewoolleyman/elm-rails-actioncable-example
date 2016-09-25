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
        , receiveCommandConnectionSendResult
        , receiveCommandInvocationResult
        , receiveEventConnectionSendResult
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
    , commandConnectionSendResult = False
    , commandInvocationResult =
        { result = "uninitialized"
        , details = []
        }
    , eventConnectionSendResult = False
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

        ReceiveCommandConnectionSendResult newCommandConnectionSendResult ->
            ( { model | commandConnectionSendResult = newCommandConnectionSendResult }, Cmd.none )

        ReceiveCommandInvocationResult newCommandInvocationResult ->
            ( { model | commandInvocationResult = newCommandInvocationResult }, Cmd.none )

        ReceiveEventConnectionSendResult newEventConnectionSendResult ->
            ( { model | eventConnectionSendResult = newEventConnectionSendResult }, Cmd.none )

        ApplyEvents domainEventsValueFromPort ->
            let
                domainEvents =
                    decodeDomainEventsFromPort domainEventsValueFromPort

                ( newDomainState, newDomainEventHistory ) =
                    applyDomainEvents domainEvents model.domainState model.domainEventHistory
            in
                ( { model | domainState = newDomainState, domainEventHistory = newDomainEventHistory }, Cmd.none )
