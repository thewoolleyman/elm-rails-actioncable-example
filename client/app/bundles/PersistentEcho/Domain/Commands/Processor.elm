module PersistentEcho.Domain.Commands.Processor exposing (..)

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
import PersistentEcho.Domain.Commands.UpdateText exposing (updateText)
import PersistentEcho.Domain.Commands.UpdateNumber exposing (updateNumber)
import List exposing (map)
import Json.Encode exposing (..)


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


portedDomainCommand : DomainCommand -> Value
portedDomainCommand domainCommand =
    case domainCommand of
        UpdateTextCommand command ->
            let
                dataValue =
                    object
                        [ ( "text", string command.data.text )
                        ]
            in
                jsonDomainCommand command.name dataValue

        -- TODO: Duplication here
        UpdateNumberCommand command ->
            let
                dataValue =
                    object
                        [ ( "integer", int command.data.integer )
                        ]
            in
                jsonDomainCommand command.name dataValue



-- TODO: Duplication here


jsonDomainCommand : String -> Value -> Value
jsonDomainCommand name dataObject =
    let
        jsonValue =
            object
                [ ( "name", string name )
                , ( "data", dataObject )
                ]
    in
        jsonValue


logDomainCommandToHistory : DomainCommand -> Model -> Model
logDomainCommandToHistory domainCommand model =
    let
        newDomainCommandHistory =
            domainCommand :: model.domainCommandHistory
    in
        { model | domainCommandHistory = newDomainCommandHistory }
