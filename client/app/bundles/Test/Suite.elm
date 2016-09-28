module Suite exposing (main)

import Test exposing (concat)
import Test.Runner.Log
import Html.App
import Html
import PersistentEcho.Domain.Events.DecoderTest exposing (..)
import PersistentEcho.Utils.ReverserTest exposing (..)


main : Program Never
main =
    Html.App.beginnerProgram
        { model = ()
        , update = \_ _ -> ()
        , view = \() -> Html.text "Check the console for useful output!"
        }
        |> Test.Runner.Log.run
            (Test.concat
                [ testReverser
                , testTextualEntityParsing
                , testNumericEntityParsing
                ]
            )
