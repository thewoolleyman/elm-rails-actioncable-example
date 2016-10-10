module Domain.Events.TextualEntityCreated exposing (textualEntityCreated)

import Domain.Types exposing (DomainState, TextualEntity)


textualEntityCreated : TextualEntity -> DomainState -> DomainState
textualEntityCreated newTextualEntity domainState =
    { domainState | textualEntities = newTextualEntity :: domainState.textualEntities }
