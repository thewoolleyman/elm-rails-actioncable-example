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
