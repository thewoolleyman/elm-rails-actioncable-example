module PersistentEcho.Domain.Events.Processor
    exposing
        ( processEvent
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
    NOTE: union type constructors are not exposed outside of this module, as recommended by
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
