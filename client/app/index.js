'use strict';

const Elm = require('./bundles/PersistentEcho/Main.elm');
const mountNode = document.getElementById('main');
const main = Elm.Main.embed(mountNode);
const cableUrl = 'ws://127.0.0.1:3000/cable';
const actionCable = ActionCable.createConsumer(cableUrl);
const channel = actionCable.subscriptions.create('StateChannel', {
  connected() {
  },

  disconnected() {
  },

  update(state) {
    console.log("---> StateChannel performing update with state: " + state);
    return this.perform('update', { state }); // shorthand for "state: state"
  },

  received(state) {
    console.log("<--- StateChannel received state: " + state);
    main.ports.receiveUpdate.send(state);
  },
});

// TODO: is there a more elegant approach than this bind?
main.ports.publishUpdate.subscribe(channel.update.bind(channel));
