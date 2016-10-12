module Styles exposing (..)

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
    [ ( "padding", "5px 0px" )
    , ( "width", "100%" )
    ]


itemRow =
    [ ( "padding", "3px 5px 3px 5px" )
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


paneHeaderStyle : Attribute msg
paneHeaderStyle =
    style <|
        [ ( "padding", "3px 0px 3px 0px" )
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
            , ( "overflow", "scroll" )
            ]


textualEntityListItemStyle : Attribute msg
textualEntityListItemStyle =
    style <|
        [ ( "list-item-style", "none" )
        , ( "margin", "0px" )
        , ( "padding", "0px" )
        ]


textualEntityFormStyle : Attribute msg
textualEntityFormStyle =
    style <|
        append itemRow
            [ ( "border-top", "1px solid" )
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


historyItemRowStyle : Attribute msg
historyItemRowStyle =
    style <|
        itemRow


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
        append itemRow
            [ border
            , ( "background", lightblue )
            , ( "flex", "1 0 100px" )
            , ( "padding", "5px" )
            ]


channelConnectedRowStyle : Attribute msg
channelConnectedRowStyle =
    style <|
        [ displayFlex
        , ( "flex-direction", "row" )
        , ( "flex", "3 0 30px" )
        , ( "justify-content", "space-between" )
        ]


greenBackgroundStyle : Attribute msg
greenBackgroundStyle =
    style <|
        [ ( "background", "green" )
        ]


redBackgroundStyle : Attribute msg
redBackgroundStyle =
    style <|
        [ ( "background", "red" )
        ]
