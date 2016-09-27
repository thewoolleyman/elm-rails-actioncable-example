'use strict';

const channelSubscriber = require('./channel_subscriber.js');

/*
 setupEventsSinceChannel() is one of the javascript shims between ActionCable and Elm ports.
 This one is for a single client to request for previous "missed" events to be sent from the server to the Elm client.

 This channel broadcasts messages from the server ONLY to the current client, not all clients
*/
const setupEventsSinceChannel = (elmApp, actionCable) => {
  // 'EventsSinceChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channelPerform = channelSubscriber.subscribe(
    'EventsSinceChannel',
    actionCable,
    elmApp.ports.receiveChannelConnectedStatus,
    elmApp.ports.logChannelConnectionSendFailure,
    elmApp.ports.applyEvents
  );

  // `getEventsSince` is a custom callback function the Elm port/command calls
  // to retrieve an initial set of events which have occurred since a given sequence number
  const getEventsSince = (sequence) => {
    channelPerform('get_events_since', sequence);
  };

  // subscribe to an "outgoing" Elm port/command on the client with an ActionCable callback function which will
  // invoke a command the server via websockets
  elmApp.ports.getEventsSince.subscribe(getEventsSince);
};

exports.setupEventsSinceChannel = setupEventsSinceChannel;
