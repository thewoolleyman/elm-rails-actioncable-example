module Domain.Events.NumberUpdated exposing (numberUpdated)

import Domain.Types exposing (DomainState, NumericEntity)
import Domain.ListUtils exposing (updateEntityHavingId)


numberUpdated : NumericEntity -> DomainState -> DomainState
numberUpdated newNumericEntity domainState =
    let
        updaterWithUpdates =
            updater newNumericEntity

        entityId =
            newNumericEntity.entityId

        newNumericEntities =
            updateEntityHavingId updaterWithUpdates entityId domainState.numericEntities
    in
        { domainState | numericEntities = newNumericEntities }


updater : NumericEntity -> NumericEntity -> NumericEntity
updater entityWithUpdates entityToUpdate =
    { entityToUpdate | integer = entityWithUpdates.integer }
