module PersistentEcho.State exposing (..)

import PersistentEcho.Ports exposing (..)
import PersistentEcho.Types exposing (..)
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
        )


initialModel : Model
initialModel =
    { commandChannelStatus = "uninitialized"
    , eventChannelStatus = "uninitialized"
    , commandConnectionSendResult = False
    , commandInvocationResult =
        { result = "uninitialized"
        , details = []
        }
    , eventConnectionSendResult = False
    , domainCommandHistory = []
    , domainEventHistory = []
    , domainState =
        { text = ""
        , integer = 0
        }
    }


initialCommands : Cmd Msg
initialCommands =
    Cmd.batch
        [ getEventsSince { data = 0 }
        ]


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

        ReceiveCommandChannelStatus newCommandChannelStatus ->
            ( { model | commandChannelStatus = newCommandChannelStatus }, Cmd.none )

        ReceiveEventChannelStatus newEventChannelStatus ->
            ( { model | eventChannelStatus = newEventChannelStatus }, Cmd.none )

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
