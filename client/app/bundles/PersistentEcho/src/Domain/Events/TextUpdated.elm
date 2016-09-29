module Domain.Events.TextUpdated exposing (textUpdated)

import Types exposing (DomainState)


textUpdated : String -> DomainState -> DomainState
textUpdated newText domainState =
    { domainState | text = newText }
