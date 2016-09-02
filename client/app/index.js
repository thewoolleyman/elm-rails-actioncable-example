'use strict';

const cableUrl = appSettings.websocketProtocol + '//' + appSettings.origin + '/cable';
const actionCable = ActionCable.createConsumer(cableUrl);
const channelStatusNode = document.getElementById('channelStatus');
const mountNode = document.getElementById('main');
// embed the Elm entry point module which contains the `main` function into the HTML document
const Elm = require('./bundles/PersistentEcho/App.elm');
const app = Elm.PersistentEcho.App.embed(mountNode);

// 'StateChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
const channel = actionCable.subscriptions.create('StateChannel', {
  connected() {
    // called when websocket channel is connected - notify "incoming" Elm port/subscription
    app.ports.receiveChannelStatus.send('connected channel with identifier: ' + this.identifier);
  },

  disconnected() {
    // called when websocket channel is disconnected - notify "incoming" Elm port/subscription
    app.ports.receiveChannelStatus.send('disconnected channel with identifier: ' + this.identifier);
  },

  // `received` is the standard function ActionCable calls when `ActionCable.server.broadcast` is
  // invoked via Rails on the server to send data to the client on this channel via websockets.
  // i.e. the single server -> client websocket connections
  received(state) {
    console.log("<--- StateChannel received state: " + state);
    // send data received from the server on this ActionCable websocket channel to an "incoming" Elm port/subscription
    app.ports.receiveUpdate.send(state);
  },
});

// `publishUpdate` is a custom callback function the Elm port/command calls to send data to the server via websockets.
const publishUpdate = (state) => {
  console.log("---> StateChannel performing update with state: " + state);
  // send data to the server over the websocket channel
  // 'update' must correspond to a ruby method defined on this channel's corresponding Rails subclass
  // of ApplicationCable::Channel on the server.
  return channel.perform('update', { state }); // shorthand for "state: state"
};

// subscribe to an "outgoing" Elm port/command on the client with an ActionCable callback function which will
// send data to the server via websockets when it is invoked
app.ports.publishUpdate.subscribe(publishUpdate);
