'use strict';

/*
 subscribe() is a helper method to shim between ActionCable and Elm ports.  It is used by
 individual ActionCable channels to subscribe, and handle the connected(), disconnected(),
 and received() standard ActionCable callbacks.  It also returns a handle to the channel to
 allow outbound port/command callbacks from Elm to the server to be defined.
 */
const subscribe = (channelName,
                   actionCable,
                   elmChannelConnectedStatusPortSubscription,
                   elmLogChannelConnectionSendFailurePortSubscription,
                   elmChannelPortSubscription) => {
  // 'CommandChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channel = actionCable.subscriptions.create(channelName, {
    connected() {
      // called when websocket channel is connected - notify "incoming" Elm ChannelStatus port/subscription
      this._sendChannelConnectedStatusToPort(true);
    },

    disconnected() {
      // called when websocket channel is disconnected - notify "incoming" Elm ChannelStatus port/subscription
      this._sendChannelConnectedStatusToPort(false);
    },

    // TODO: Move this to its own channel
    // `received` is the standard function ActionCable calls when `ActionCable.server.broadcast` is
    // invoked via Rails on the server to send data to the client on this channel via websockets.
    // i.e. the single server -> client websocket connection for this channel
    received(broadcastedPayload) {
      console.log('<--- ' + channelName + ' received broadcasted payload:');
      console.log(broadcastedPayload);
      // send data received from the server on this ActionCable websocket channel to an "incoming" Elm port/subscription
      elmChannelPortSubscription.send(broadcastedPayload);
    },

    _sendChannelConnectedStatusToPort(connected) {
      elmChannelConnectedStatusPortSubscription.send(
        {
          channel: channelName,
          connected: connected,
        }
      );
    },
  });

  const channelPerform = (action, data) => {
    console.log('---> Channel ' + channelName + ' performing action ' + action + ' with data:');
    console.log(data);
    // send data to the server over the websocket channel
    // 'action' must correspond to a ruby method defined on this channel's corresponding Rails subclass
    // of ApplicationCable::Channel on the server.
    const channelConnectionSendResult = channel.perform(action, data);
    // return values of outbound port callback functions are ignored by Elm, so even if we did want to send it back
    // to Elm, we would have to pass it back via an inbound port.  However,
    // all ActionCable gives us from channel.perform is true or false based if connection was open or not,
    // so if it is false (meaning the connection send failed under the covers), we will log back to Elm.
    // In a real app, it could be retried or handled accordingly.
    if (!channelConnectionSendResult) {
      elmLogChannelConnectionSendFailurePortSubscription.send(
        {
          channelName: channelName
          , action: action
          , data: data
        }
      );
    }
  };

  return channelPerform;
};

exports.subscribe = subscribe;
