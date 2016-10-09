module Tests exposing (..)

import Test exposing (Test, describe)
import App
import Domain.Events.DecoderTest exposing (..)
import Utils.ReverserTest exposing (..)


all : Test
all =
    describe "Suites"
        [ testReverser
        , testTextualEntityParsing
        , testNumericEntityParsing
        ]
