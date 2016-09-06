'use strict';

/*
 Entry point to Elm app.
*/

const commandChannel = require('./command_channel.js');
const eventChannel = require('./event_channel.js');

const mountNode = document.getElementById('main');
// embed the Elm entry point module which contains the `main` function into the HTML document
const Elm = require('./bundles/PersistentEcho/App.elm');
const elmApp = Elm.PersistentEcho.App.embed(mountNode);
const cableUrl = appSettings.websocketProtocol + '//' + appSettings.origin + '/cable';
const actionCable = ActionCable.createConsumer(cableUrl);

console.log('CALLING SETUP COMMAND CHANNEL');
commandChannel.setupCommandChannel(elmApp, actionCable);
console.log('CALLING SETUP EVENT CHANNEL');
eventChannel.setupEventChannel(elmApp, actionCable);
