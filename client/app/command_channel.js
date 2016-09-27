'use strict';

const channelSubscriber = require('./channel_subscriber.js');

/*
 setupCommandChannel() is one of the javascript shims between ActionCable and Elm ports.
 This one is for outbound domain commands being sent from the Elm client to the server and their (inbound) results.
 */
const setupCommandChannel = (elmApp, actionCable) => {
  // 'CommandChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channelPerform = channelSubscriber.subscribe(
    'CommandChannel',
    actionCable,
    elmApp.ports.receiveChannelConnectedStatus,
    elmApp.ports.logChannelConnectionSendFailure,
    elmApp.ports.receiveCommandInvocationResult
  );

  // `invokeCommandOnServer` is a custom callback function the Elm port/command calls
  // to invoke a command on the server via websockets.
  const invokeCommandOnServer = (domainCommand) => {
    channelPerform('invoke', domainCommand);
  };

  // subscribe to an "outgoing" Elm port/command on the client with an ActionCable callback function which will
  // invoke a command the server via websockets
  elmApp.ports.invokeCommandOnServer.subscribe(invokeCommandOnServer);
};

exports.setupCommandChannel = setupCommandChannel;
