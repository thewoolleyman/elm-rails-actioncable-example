module Domain.Commands.Encoder exposing (portedDomainCommand)

import Domain.Commands.Types
    exposing
        ( DomainCommand
        , DomainCommand(..)
        )
import Json.Encode exposing (..)


portedDomainCommand : DomainCommand -> Value
portedDomainCommand domainCommand =
    case domainCommand of
        -- TODO: See if duplication can be DRY'd up after more different commands are created
        CreateTextualEntityCommand command ->
            let
                dataValue =
                    object []
            in
                jsonDomainCommand command.name dataValue

        UpdateTextualEntityCommand command ->
            let
                dataValue =
                    object
                        [ ( "text", string command.data.text )
                        ]
            in
                jsonDomainCommand command.name dataValue

        UpdateNumericEntityCommand command ->
            let
                dataValue =
                    object
                        [ ( "integer", int command.data.integer )
                        ]
            in
                jsonDomainCommand command.name dataValue


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
