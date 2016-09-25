'use strict';

const channelSubscriber = require('./channel_subscriber.js');

/*
 setupEventsSinceChannel() is one of the javascript shims between ActionCable and Elm ports.
 This one is for a single client to request for previous "missed" events to be sent from the server to the Elm client.

 This channel broadcasts messages from the server ONLY to the current client, not all clients
*/
const setupEventsSinceChannel = (elmApp, actionCable) => {
  // 'EventsSinceChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channel = channelSubscriber.subscribe(
    'EventsSinceChannel',
    actionCable,
    elmApp.ports.receiveChannelConnectedStatus,
    elmApp.ports.applyEvents
  );

  // `getEventsSince` is a custom callback function the Elm port/command calls
  // to retrieve an initial set of events which have occurred since a given sequence number
  const getEventsSince = (sequence) => {
    console.log('---> EventsSinceChannel getting events since sequence ' + sequence.data);
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

exports.setupEventsSinceChannel = setupEventsSinceChannel;
