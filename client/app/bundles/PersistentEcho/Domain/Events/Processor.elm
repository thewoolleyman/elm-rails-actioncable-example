module PersistentEcho.Domain.Events.Processor
    exposing
        ( decodeDomainEventsFromPort
        , processEvent
        , applyDomainEvents
        , latestDomainEventSequence
        )

import PersistentEcho.Types exposing (DomainState)
import PersistentEcho.Domain.Events.Types
    exposing
        ( DomainEvent
        , Sequence
        , DomainEventHistory
        , EventData(..)
        , invalidDomainEvent
        , textualEntityUpdatedEventData
        , numericEntityUpdatedEventData
        )
import PersistentEcho.Domain.Events.TextUpdated exposing (textUpdated)
import PersistentEcho.Domain.Events.NumberUpdated exposing (numberUpdated)
import List exposing (foldl, head)
import Maybe exposing (withDefault, map)
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


applyDomainEvents : List DomainEvent -> DomainState -> DomainEventHistory -> ( DomainState, DomainEventHistory )
applyDomainEvents domainEvents domainState domainEventHistory =
    let
        newDomainState =
            foldl processEvent domainState domainEvents

        newDomainEventHistory =
            foldl logDomainEventToHistory domainEventHistory domainEvents
    in
        ( newDomainState, newDomainEventHistory )


{-|
    TODO: How to not expose the union type constructors, as recommended by
     http://package.elm-lang.org/help/design-guidelines#keep-tags-and-record-constructors-secret
-}
processEvent : DomainEvent -> DomainState -> DomainState
processEvent domainEvent domainState =
    let
        eventData =
            domainEvent.data
    in
        case eventData of
            TextualEntityUpdated text ->
                textUpdated text domainState

            NumericEntityUpdated integer ->
                numberUpdated integer domainState

            Invalid msg ->
                domainState


logDomainEventToHistory : DomainEvent -> DomainEventHistory -> DomainEventHistory
logDomainEventToHistory domainEvent domainEventHistory =
    domainEvent :: domainEventHistory


latestDomainEventSequence : DomainEventHistory -> Sequence
latestDomainEventSequence domainEventHistory =
    map (\domainEvent -> domainEvent.sequence) (head domainEventHistory) |> withDefault 0
