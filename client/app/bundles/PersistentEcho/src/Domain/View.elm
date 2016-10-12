module Domain.View exposing (domainStateRow)

import Types exposing (Msg(..))
import Domain.Commands.CreateTextualEntity exposing (createTextualEntity)
import Domain.Commands.UpdateTextualEntity exposing (updateTextualEntity)
import Domain.Commands.UpdateNumericEntity exposing (updateNumericEntity)
import Domain.Types exposing (DomainState, TextualEntity, NumericEntity)
import Utils.Reverser exposing (reverseIt)
import Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)
import List exposing (head)


domainStateRow : DomainState -> Html Msg
domainStateRow domainState =
    div [ domainStateRowStyle ]
        [ textualPane domainState.textualEntities
        , numericPane domainState.numericEntities
        ]


textualPane : List TextualEntity -> Html Msg
textualPane textualEntities =
    div [ textualPaneStyle ]
        [ div [ paneHeaderStyle ]
            [ text "Textual Entities State: "
            , createTextualEntityButton
            ]
        , Keyed.ul [ textualEntityListItemStyle ] <| List.map textualEntityFormKeyedEntry textualEntities
        ]


createTextualEntityButton : Html Msg
createTextualEntityButton =
    button [ onClick (createTextualEntity) ] [ text "Create Textual Entity" ]


textualEntityFormKeyedEntry : TextualEntity -> ( String, Html Msg )
textualEntityFormKeyedEntry textualEntity =
    ( textualEntity.entityId, lazy textualEntityForm textualEntity )


textualEntityForm : TextualEntity -> Html Msg
textualEntityForm textualEntity =
    div [ textualEntityFormStyle ]
        [ span []
            [ span [] [ text "Send the text down: " ]
            , input
                [ placeholder "type some text"
                , value textualEntity.text
                , onInput <| updateTextualEntity textualEntity.entityId
                ]
                []
            ]
        , span []
            [ span [] [ text " Flip it and reverse it: " ]
            , span []
                [ a [ href "https://youtu.be/UODX_pYpVxk", target "_" ] [ text (reverseIt textualEntity.text) ]
                ]
            ]
        ]


numericPane : List NumericEntity -> Html Msg
numericPane numericEntities =
    let
        numericEntity =
            head numericEntities

        numericEntityFormRow =
            case numericEntity of
                Just entity ->
                    numericEntityForm entity

                Nothing ->
                    div [] [ text "No Numeric Entity" ]
    in
        div [ numericPaneStyle ]
            [ div [] [ text "Numeric Entity State:" ]
            , numericEntityFormRow
            ]


numericEntityForm : NumericEntity -> Html Msg
numericEntityForm numericEntity =
    div []
        [ div []
            [ span [] [ text "The number is currently: " ]
            , span [] [ text (toString numericEntity.integer) ]
            ]
        , div []
            [ button [ onClick (updateNumericEntity numericEntity.integer) ] [ text "Increment" ]
            ]
        ]
