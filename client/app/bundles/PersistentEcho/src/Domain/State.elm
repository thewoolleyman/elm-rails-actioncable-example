module Domain.State exposing (initialDomainState)

import Domain.Types exposing (DomainState)


initialDomainState : DomainState
initialDomainState =
    { textualEntities =
        [ { entityId = "1"
          , text = ""
          }
        ]
    , numericEntities =
        [ { entityId = "1"
          , integer = 0
          }
        ]
    }
