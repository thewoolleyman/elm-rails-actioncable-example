module PersistentEcho.Styles exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (append)


-- reusable style variables


greyMedium =
    "#B4BAC2"


lightblue =
    "#BFD7FF"


green1 =
    "#A7C4B5"


green2 =
    "#A9D8B8"


green3 =
    "#BEFFC7"


green4 =
    "#EEFFE7"


border =
    ( "border", "1px solid" )


displayFlex =
    ( "display", "flex" )


column =
    [ ( "padding", "5px" )
    , ( "width", "100%" )
    ]



-- styles


pageStyle : Attribute msg
pageStyle =
    style <|
        [ displayFlex
        , ( "flex-direction", "column" )
        , ( "justify-content", "space-between" )
        , ( "width", "100%" )
        , ( "font-family", "sans-serif" )
        ]


headerRowStyle : Attribute msg
headerRowStyle =
    style <|
        [ border
        , ( "background", greyMedium )
        , ( "font-weight", "bold" )
        , ( "padding", "3px" )
        ]


domainStateRowStyle : Attribute msg
domainStateRowStyle =
    style <|
        [ displayFlex
        , ( "flex-direction", "row" )
        , ( "flex", "3 0 100px" )
        , ( "justify-content", "space-between" )
        ]


textualPaneStyle : Attribute msg
textualPaneStyle =
    style <|
        append column
            [ border
            , ( "background", green2 )
            ]


numericPaneStyle : Attribute msg
numericPaneStyle =
    style <|
        append column
            [ border
            , ( "background", green3 )
            ]


historyRowStyle : Attribute msg
historyRowStyle =
    style <|
        [ border
        , displayFlex
        , ( "background", green1 )
        , ( "flex-direction", "row" )
        , ( "flex", "3 0 200px" )
        , ( "justify-content", "space-between" )
        ]


historyPaneStyle : Attribute msg
historyPaneStyle =
    style <|
        append column
            [ border
            , ( "overflow", "scroll" )
            ]


channelStatusRowStyle : Attribute msg
channelStatusRowStyle =
    style <|
        [ border
        , ( "background", lightblue )
        , ( "flex", "1 0 100px" )
        , ( "padding", "5px" )
        ]
