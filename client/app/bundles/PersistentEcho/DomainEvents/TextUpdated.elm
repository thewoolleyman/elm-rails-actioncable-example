module PersistentEcho.DomainEvents.TextUpdated exposing (textUpdated)

import PersistentEcho.Types exposing (..)


textUpdated : String -> DomainState -> DomainState
textUpdated newText domainState =
    { domainState | text = newText }
