module Domain.State exposing (initialDomainState)

import Domain.Types exposing (DomainState)


initialDomainState : DomainState
initialDomainState =
    { textualEntities = []
    , numericEntities =
        [ { entityId = "1"
          , integer = 0
          }
        ]
    }
