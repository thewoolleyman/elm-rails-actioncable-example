port module Main exposing (..)

import Html exposing (Html, Attribute, div, input, text)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String

main =
  Html.program -- change to non beginnerProgram
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { state : String
  }

model : Model
model =
  Model ""

init : (Model, Cmd Msg)
init =
  (Model "", Cmd.none)

-- UPDATE

type Msg
  = Publish String
  | Receive String

port publishUpdate : String -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Publish newState ->
      (model, publishUpdate newState)
    Receive newState ->
      ({ model | state = newState }, Cmd.none)

-- SUBSCRIPTIONS

port receiveUpdate : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  receiveUpdate Receive

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "type model state", value model.state, onInput Publish ] []
    , div [] [ text (model.state) ]
    ]
