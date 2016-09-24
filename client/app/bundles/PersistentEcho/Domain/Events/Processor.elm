module PersistentEcho.Domain.Events.Processor exposing (..)

import List exposing (foldl)
import PersistentEcho.Types exposing (..)
import PersistentEcho.Domain.Events.TextUpdated exposing (textUpdated)
import PersistentEcho.Domain.Events.NumberUpdated exposing (numberUpdated)
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


-- NOTE: We have to manually decode the event rather than letting port, because ports don't
--       support native data types.  See: https://github.com/elm-lang/elm-compiler/issues/490


decodeDomainEventsFromPort : Value -> List DomainEvent
decodeDomainEventsFromPort eventsPayload =
    case decodeValue eventsDecoder eventsPayload of
        Ok domainEvents ->
            domainEvents

        Err errorMessage ->
            [ invalidDomainEvent errorMessage ]



--    Err errorMessage -> Debug.log ("Invalid domain event payload Received.  Error message: " ++ message) [invalidDomainEvent errorMessage]


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


eventDataDecoderForEventType : String -> Decoder EventData
eventDataDecoderForEventType eventType =
    case eventType of
        "TextualEntityUpdated" ->
            textualEntityUpdatedEventDataDecoder

        "NumericEntityUpdated" ->
            numericEntityUpdatedEventDataDecoder

        _ ->
            fail ("Invalid domain event type received. Error message: '" ++ eventType ++ "'")



-- Note that this uses the standard Elm Json.Decode library approach using `object2` and `:=`


textualEntityUpdatedEventDataDecoder : Decoder EventData
textualEntityUpdatedEventDataDecoder =
    object1 textualEntityUpdatedEventData ("text" := string)



-- Note that this uses the elm-community/json-extra Json.Decode.Extra library approach using `succeed` and `|=`


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



-- See https://gist.github.com/evancz/2b2ba366cae1887fe621 for state architecture guidelines


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

            Null ->
                domainState

            Invalid msg ->
                domainState



--      TextualEntityUpdatedEventData -> textUpdated eventData domainState
--      NumericEntityUpdatedEventData -> numberUpdated eventData domainState
-- TODO: ^^^
-- 1. How to handle invalid event name passed in via port? See: https://github.com/elm-lang/elm-compiler/issues/490
-- 2. How to not expose the union type constructors, as recommended by http://package.elm-lang.org/help/design-guidelines#keep-tags-and-record-constructors-secret


logDomainEventToHistory : DomainEvent -> DomainEventHistory -> DomainEventHistory
logDomainEventToHistory domainEvent domainEventHistory =
    domainEvent :: domainEventHistory
