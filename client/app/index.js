'use strict';

/*
 Set a random "current_user" id in a cookie.  In a real app this would be handled by server authentication
*/

const uuid = require("uuid");
const current_user_id = uuid.v4();
document.cookie = 'current_user=' + current_user_id;

/*
 Entry point to Elm app.
*/

const commandChannel = require('./command_channel.js');
const eventChannel = require('./event_channel.js');
const eventsSinceChannel = require('./events_since_channel.js');

const mountNode = document.getElementById('main');
// embed the Elm entry point module which contains the `main` function into the HTML document
const Elm = require('./bundles/PersistentEcho/src/App.elm');
const elmApp = Elm.App.embed(mountNode);
const cableUrl = appSettings.websocketProtocol + '//' + appSettings.origin + '/cable';
const actionCable = ActionCable.createConsumer(cableUrl);

console.log('CALLING SETUP COMMAND CHANNEL');
commandChannel.setupCommandChannel(elmApp, actionCable);
console.log('CALLING SETUP EVENT CHANNEL');
eventChannel.setupEventChannel(elmApp, actionCable);
console.log('CALLING SETUP EVENTS SINCE CHANNEL');
eventsSinceChannel.setupEventsSinceChannel(elmApp, actionCable);
