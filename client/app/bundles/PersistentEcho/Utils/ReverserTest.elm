module Utils.ReverserTest exposing (..)

import Test exposing (..)
import Expect

import Utils.Reverser exposing (reverseIt)

reverser =
  describe "Reverser"
    [ describe "reverseIt"
      [ test "reverses" <|
        \() ->
          reverseIt "Missy Elliott"
            |> Expect.equal "ttoillE yssiM"
      ]
    ]
