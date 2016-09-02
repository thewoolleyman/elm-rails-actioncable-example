port module PersistentEcho.Ports exposing (..)

import PersistentEcho.Types exposing (..)

port publishUpdate : String -> Cmd msg

port receiveUpdate : (String -> msg) -> Sub msg

port receiveChannelStatus : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ receiveUpdate ReceiveUpdate
  , receiveChannelStatus ReceiveChannelStatus
  ]

