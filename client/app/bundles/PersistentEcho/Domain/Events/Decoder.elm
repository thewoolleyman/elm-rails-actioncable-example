module PersistentEcho.Domain.Events.Decoder exposing (decodeDomainEventsFromPort)

import PersistentEcho.Domain.Events.Types
    exposing
        ( DomainEvent
        , EventData(..)
        , invalidDomainEvent
        , textualEntityUpdatedEventData
        , numericEntityUpdatedEventData
        )
import Json.Encode exposing (Value)
import Json.Decode.Extra exposing ((|:))
import Json.Decode
    exposing
        ( Decoder
        , decodeValue
        , succeed
        , fail
        , string
        , int
        , list
        , object1
        , object2
        , object3
        , at
        , andThen
        , (:=)
        )


{-
   NOTE: We have to manually JSOn decode the event rather than letting the port handle it, because ports don't
   support native data types.  See: https://github.com/elm-lang/elm-compiler/issues/490
-}


decodeDomainEventsFromPort : Value -> List DomainEvent
decodeDomainEventsFromPort eventsPayload =
    case decodeValue eventsDecoder eventsPayload of
        Ok domainEvents ->
            domainEvents

        Err errorMessage ->
            [ invalidDomainEvent errorMessage ]


eventsDecoder : Decoder (List DomainEvent)
eventsDecoder =
    list eventDecoder


eventDecoder : Decoder DomainEvent
eventDecoder =
    object3 DomainEvent
        ("id" := string)
        ("sequence" := int)
        eventDataDecoder


eventDataDecoder : Decoder EventData
eventDataDecoder =
    ("type" := string) `andThen` decodeEventData


decodeEventData : String -> Decoder EventData
decodeEventData eventType =
    at [ "data" ] <| eventDataDecoderForEventType eventType


{-|
    TODO: There could be better handling of invalid event types passed in via the port.  Currently
          it's just added as an "invalid" event.  In a real app, you'd probably want to force a reload of the page,
          since presumably (unless you have a bug) the server has sent a new event type
          that the current client code doesn't support.  Note that supporting native Elm types over ports would
          make this better.  See: https://github.com/elm-lang/elm-compiler/issues/490
-}
eventDataDecoderForEventType : String -> Decoder EventData
eventDataDecoderForEventType eventType =
    case eventType of
        "TextualEntityUpdated" ->
            textualEntityUpdatedEventDataDecoder

        "NumericEntityUpdated" ->
            numericEntityUpdatedEventDataDecoder

        _ ->
            fail ("Invalid domain event type received. Error message: '" ++ eventType ++ "'")


{-|
    Note: this uses the standard Elm Json.Decode library approach using `object1` and `:=`
-}
textualEntityUpdatedEventDataDecoder : Decoder EventData
textualEntityUpdatedEventDataDecoder =
    object1 textualEntityUpdatedEventData ("text" := string)


{-|
    Note: numericEntityUpdatedEventDataDecoder uses the elm-community/json-extra Json.Decode.Extra library approach
          using `succeed` and `|=`
-}
numericEntityUpdatedEventDataDecoder : Decoder EventData
numericEntityUpdatedEventDataDecoder =
    succeed numericEntityUpdatedEventData
        |: ("integer" := int)
