module Domain.ListUtils exposing (updateEntityHavingId)

import Domain.Types exposing (Entity)
import List exposing (map)


updateEntityHavingId : (Entity a -> Entity a) -> String -> List (Entity a) -> List (Entity a)
updateEntityHavingId updater entityId entities =
    let
        updateMethod =
            updateIfIdMatches updater entityId
    in
        map updateMethod entities


updateIfIdMatches : (Entity a -> Entity a) -> String -> Entity a -> Entity a
updateIfIdMatches updater entityId entityToMaybeUpdate =
    if entityToMaybeUpdate.entityId == entityId then
        updater entityToMaybeUpdate
    else
        entityToMaybeUpdate
