module PersistentEcho.Domain.Commands.Processor exposing (..)

import PersistentEcho.Ports exposing (invokeCommandOnServer)
import PersistentEcho.Types exposing (Model)
import PersistentEcho.Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommand(..)
        )
import List exposing (map)
import Json.Encode exposing (..)


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
