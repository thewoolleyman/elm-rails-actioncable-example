module Domain.Events.NumberUpdated exposing (numberUpdated)

import Types exposing (DomainState)


numberUpdated : Int -> DomainState -> DomainState
numberUpdated newInteger domainState =
    { domainState | integer = newInteger }
