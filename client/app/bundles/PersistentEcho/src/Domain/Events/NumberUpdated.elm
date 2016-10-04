module Domain.Events.NumberUpdated exposing (numberUpdated)

import Domain.Types exposing (DomainState)


numberUpdated : Int -> DomainState -> DomainState
numberUpdated newInteger domainState =
    { domainState | integer = newInteger }
