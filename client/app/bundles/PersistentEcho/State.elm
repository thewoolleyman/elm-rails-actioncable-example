module PersistentEcho.State exposing (..)

import PersistentEcho.Ports exposing (..)
import PersistentEcho.Types exposing (..)


initialModel : Model
initialModel =
    Model ""

initialCommands : Cmd Msg
initialCommands =
    Cmd.batch
        [ Cmd.none
        ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Publish newState ->
      (model, publishUpdate newState)
    Receive newState ->
      ({ model | state = newState }, Cmd.none)
