module Domain.View exposing (domainStateRow)

import Types exposing (Msg(..))
import Domain.Commands.UpdateTextualEntity exposing (updateTextualEntity)
import Domain.Commands.UpdateNumericEntity exposing (updateNumericEntity)
import Domain.Types exposing (DomainState, TextualEntity, NumericEntity)
import Utils.Reverser exposing (reverseIt)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import List exposing (head)


domainStateRow : DomainState -> Html Msg
domainStateRow domainState =
    let
        textualEntity =
            head domainState.textualEntities

        textualPaneContent =
            case textualEntity of
                Just entity ->
                    textualPane entity

                Nothing ->
                    div [ textualPaneStyle ] [ text "No Textual Entities" ]

        numericEntity =
            head domainState.numericEntities

        numericPaneContent =
            case numericEntity of
                Just entity ->
                    numericPane entity

                Nothing ->
                    div [ numericPaneStyle ] [ text "No Numeric Entities" ]
    in
        div [ domainStateRowStyle ]
            [ textualPaneContent
            , numericPaneContent
            ]


textualPane : TextualEntity -> Html Msg
textualPane textualEntity =
    div [ textualPaneStyle ]
        [ div []
            [ text "Textual Entity State:" ]
        , div []
            [ span [] [ text "Send the text down: " ]
            , input [ placeholder "type some text", value textualEntity.text, onInput updateTextualEntity ] []
            ]
        , div []
            [ span [] [ text "Flip it and reverse it: " ]
            , span []
                [ a [ href "https://youtu.be/UODX_pYpVxk", target "_" ] [ text (reverseIt textualEntity.text) ]
                ]
            ]
        ]


numericPane : NumericEntity -> Html Msg
numericPane numericEntity =
    div [ numericPaneStyle ]
        [ div []
            [ text "Numeric Entity State:" ]
        , div []
            [ span [] [ text "The number is currently: " ]
            , span [] [ text (toString numericEntity.integer) ]
            ]
        , div []
            [ button [ onClick (InvokeDomainCommand <| updateNumericEntity numericEntity.integer) ] [ text "Increment" ]
            ]
        ]
