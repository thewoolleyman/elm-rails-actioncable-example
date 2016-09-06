'use strict';

/*
 setupEventChannel() is one of two javascript shims between ActionCable and Elm ports.
 The duplication between them could be DRYed up, but they are left separate in this example app for clarity.
 This one is for inbound events being sent from the server to the Elm client.  There is no outbound port,
 because there's no response necessary to the server, the events are already persisted on the server and the
 client must process them.
 */
const setupEventChannel = (elmApp, actionCable) => {
  // 'EventChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channel = actionCable.subscriptions.create('EventChannel', {
    connected() {
      // called when websocket channel is connected - notify "incoming" Elm port/subscription
      elmApp.ports.receiveEventChannelStatus.send('connected channel with identifier: ' + this.identifier);
    },

    disconnected() {
      // called when websocket channel is disconnected - notify "incoming" Elm port/subscription
      elmApp.ports.receiveEventChannelStatus.send('disconnected channel with identifier: ' + this.identifier);
    },

    // `received` is the standard function ActionCable calls when `ActionCable.server.broadcast` is
    // invoked via Rails on the server to send data to the client on this channel via websockets.
    // i.e. the single server -> client websocket connection for this channel
    received(events) {
      console.log('<--- EventChannel received events:');
      console.log(events);
      // send data received from the server on this ActionCable websocket channel to an "incoming" Elm port/subscription
      elmApp.ports.applyEvents.send(events);
    },
  });

  // `getEventsSince` is a custom callback function the Elm port/command calls
  // to retrieve an initial set of events which have occurred since a given sequence number
  const getEventsSince = (sequence) => {
    console.log('---> EventChannel getting events since sequence ' + sequence);
    // send data to the server over the websocket channel
    // 'get_events_since' must correspond to a ruby method defined on this channel's corresponding Rails subclass
    // of ApplicationCable::Channel on the server.
    const eventConnectionSendResult = channel.perform('get_events_since', sequence);
    // return values of outbound port callback functions are ignored by Elm, so we will send it back via an inbound port
    // All ActionCable gives us from channel.perform is true or false based if connection was open or not, so send that
    elmApp.ports.receiveEventConnectionSendResult.send(eventConnectionSendResult);
  };

  // subscribe to an "outgoing" Elm port/command on the client with an ActionCable callback function which will
  // invoke a command the server via websockets
  elmApp.ports.getEventsSince.subscribe(getEventsSince);
};

exports.setupEventChannel = setupEventChannel;
