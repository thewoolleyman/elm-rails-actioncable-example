module PersistentEcho.Types exposing (..)

type Msg
  = Publish String
  | ReceiveUpdate String
  | ReceiveChannelStatus ChannelStatus

type alias ChannelStatus = String

type alias Model =
    { channelStatus : ChannelStatus
    , state : String
    }
