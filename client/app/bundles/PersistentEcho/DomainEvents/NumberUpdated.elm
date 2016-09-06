module PersistentEcho.DomainEvents.NumberUpdated exposing (numberUpdated)

import PersistentEcho.Types exposing (..)


numberUpdated : Int -> DomainState -> DomainState
numberUpdated newInteger domainState =
    { domainState | integer = newInteger }
