module PersistentEcho.Domain.Events.TextUpdated exposing (textUpdated)

import PersistentEcho.Types exposing (DomainState)


textUpdated : String -> DomainState -> DomainState
textUpdated newText domainState =
    { domainState | text = newText }
