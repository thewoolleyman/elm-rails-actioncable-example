module PersistentEcho.Utils.ReverserTest exposing (reverser)

import Test exposing (..)
import Expect
import Fuzz exposing (..)
import String exposing (reverse)

import PersistentEcho.Utils.Reverser exposing (reverseIt)

reverser =
  describe "Reverser reverseIt"
    [ describe "test"
      [ test "reverses" <|
        \() ->
          reverseIt "Missy Elliott"
            |> Expect.equal "ttoillE yssiM"
      ]
    , describe "fuzz"
      [ fuzzWith { runs = 100 } ( string ) "reverses" <|
        \ str ->
          reverseIt str
            |> Expect.equal (reverse str)
      ]
    ]
