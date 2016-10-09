module Domain.Events.TextUpdated exposing (textUpdated)

import Domain.Types exposing (DomainState, TextualEntity)
import Domain.ListUtils exposing (updateEntityHavingId)


textUpdated : TextualEntity -> DomainState -> DomainState
textUpdated newTextualEntity domainState =
    let
        updaterWithUpdates =
            updater newTextualEntity

        entityId =
            newTextualEntity.entityId

        newTextualEntities =
            updateEntityHavingId updaterWithUpdates entityId domainState.textualEntities
    in
        { domainState | textualEntities = newTextualEntities }


updater : TextualEntity -> TextualEntity -> TextualEntity
updater entityWithUpdates entityToUpdate =
    { entityToUpdate | text = entityWithUpdates.text }
