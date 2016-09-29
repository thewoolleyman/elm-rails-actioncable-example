module Domain.Events.DecoderTest exposing (..)

import Domain.Events.Decoder exposing (..)
import Domain.Events.Types exposing (..)
import String
import Expect
import Test exposing (..)
import Json.Encode exposing (Value, list, string, object, int)


textualEntityUpdatedJson : Value
textualEntityUpdatedJson =
    list <|
        [ object
            [ ( "id", string "abc123" )
            , ( "type", string "TextualEntityUpdated" )
            , ( "sequence", int 1 )
            , ( "data"
              , object
                    [ ( "text", string "my text" )
                    ]
              )
            ]
        ]


numericEntityUpdatedJson : Value
numericEntityUpdatedJson =
    list <|
        [ object
            [ ( "id", string "def456" )
            , ( "type", string "NumericEntityUpdated" )
            , ( "sequence", int 2 )
            , ( "data"
              , object
                    [ ( "integer", int 42 )
                    ]
              )
            ]
        ]


testTextualEntityParsing : Test
testTextualEntityParsing =
    describe "TextualEntity"
        [ test "parses" <|
            \() ->
                decodeDomainEventsFromPort textualEntityUpdatedJson
                    |> Expect.equal
                        [ { id = "abc123"
                          , sequence = 1
                          , data = textualEntityUpdatedEventData "my text"
                          }
                        ]
        ]


testNumericEntityParsing : Test
testNumericEntityParsing =
    describe "NumericEntity"
        [ test "parses" <|
            \() ->
                decodeDomainEventsFromPort numericEntityUpdatedJson
                    |> Expect.equal
                        [ { id = "def456"
                          , sequence = 2
                          , data = numericEntityUpdatedEventData 42
                          }
                        ]
        ]
