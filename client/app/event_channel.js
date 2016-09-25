'use strict';

const channelSubscriber = require('./channel_subscriber.js');

/*
 setupEventChannel() is one of the javascript shims between ActionCable and Elm ports.
 This one is for inbound events being sent from the server to the Elm client.  There is no outbound port,
 because there's no response necessary to the server, the events are already persisted on the server and the
 client must process them.

 This channel broadcasts messages from the server to ALL clients, not just the current client.
 */
const setupEventChannel = (elmApp, actionCable) => {
  // 'EventChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channel = channelSubscriber.subscribe(
    'EventChannel',
    actionCable,
    elmApp.ports.receiveChannelConnectedStatus,
    elmApp.ports.applyEvents
  );
};

exports.setupEventChannel = setupEventChannel;
