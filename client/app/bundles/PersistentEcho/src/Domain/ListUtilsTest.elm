module Domain.ListUtilsTest exposing (..)

import Domain.ListUtils exposing (..)
import Domain.Types exposing (Entity)
import Expect
import Test exposing (..)


entities : List (Entity { value : Bool })
entities =
    [ { entityId = "a", value = False }
    , { entityId = "b", value = False }
    ]


trueDat : Entity { value : Bool } -> Entity { value : Bool }
trueDat entity =
    { entity | value = True }


testUpdateEntityHavingId : Test
testUpdateEntityHavingId =
    describe "updateEntityHavingId"
        [ test "updates entity which has id" <|
            \() ->
                updateEntityHavingId trueDat "a" entities
                    |> Expect.equal
                        [ { entityId = "a", value = True }
                        , { entityId = "b", value = False }
                        ]
        ]
