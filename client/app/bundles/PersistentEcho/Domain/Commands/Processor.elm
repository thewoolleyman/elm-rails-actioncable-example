module PersistentEcho.Domain.Commands.Processor exposing (invokeCommand)

import PersistentEcho.Ports exposing (invokeCommandOnServer)
import PersistentEcho.Types
    exposing
        ( Msg(..)
        , Model
        )
import PersistentEcho.Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommand(..)
        )
import PersistentEcho.Domain.Commands.Encoder exposing (portedDomainCommand)
import PersistentEcho.Domain.Commands.UpdateText exposing (updateText)
import PersistentEcho.Domain.Commands.UpdateNumber exposing (updateNumber)
import List exposing (map)


{-|
    NOTE: union type constructors are not exposed outside of this module, as recommended by
     http://package.elm-lang.org/help/design-guidelines#keep-tags-and-record-constructors-secret
-}
invokeCommand : DomainCommand -> Model -> ( Model, Cmd Msg )
invokeCommand domainCommand model =
    case domainCommand of
        UpdateTextCommand command ->
            let
                newModel =
                    logDomainCommandToHistory domainCommand model
            in
                ( newModel, invokeCommandOnServer (portedDomainCommand domainCommand) )

        UpdateNumberCommand command ->
            let
                newModel =
                    logDomainCommandToHistory domainCommand model
            in
                ( newModel, invokeCommandOnServer (portedDomainCommand domainCommand) )


logDomainCommandToHistory : DomainCommand -> Model -> Model
logDomainCommandToHistory domainCommand model =
    let
        newDomainCommandHistory =
            domainCommand :: model.domainCommandHistory
    in
        { model | domainCommandHistory = newDomainCommandHistory }
