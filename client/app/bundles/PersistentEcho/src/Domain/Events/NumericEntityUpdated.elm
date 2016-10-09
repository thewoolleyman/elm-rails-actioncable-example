module Domain.Events.NumericEntityUpdated exposing (numericEntityUpdated)

import Domain.Types exposing (DomainState, NumericEntity)
import Domain.ListUtils exposing (updateEntityHavingId)


numericEntityUpdated : NumericEntity -> DomainState -> DomainState
numericEntityUpdated newNumericEntity domainState =
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
