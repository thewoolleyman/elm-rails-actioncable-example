port module PersistentEcho.Ports exposing (..)

import PersistentEcho.Types exposing (..)

port publishUpdate : String -> Cmd msg

port receiveUpdate : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  receiveUpdate Receive

