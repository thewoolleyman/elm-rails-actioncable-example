module PersistentEcho.State exposing (..)

import PersistentEcho.Ports exposing (..)
import PersistentEcho.Types exposing (..)


initialModel : Model
initialModel =
    Model "uninitialized" ""

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
    ReceiveUpdate newState ->
      ({ model | state = newState }, Cmd.none)
    ReceiveChannelStatus newChannelStatus ->
      ({ model | channelStatus = newChannelStatus }, Cmd.none)
