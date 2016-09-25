'use strict';

const channelSubscriber = require('./channel_subscriber.js');

/*
 setupCommandChannel() is one of the javascript shims between ActionCable and Elm ports.
 This one is for outbound domain commands being sent from the Elm client to the server and their (inbound) results.
 */
const setupCommandChannel = (elmApp, actionCable) => {
  // 'CommandChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channel = channelSubscriber.subscribe(
    'CommandChannel',
    actionCable,
    elmApp.ports.receiveChannelConnectedStatus,
    elmApp.ports.receiveCommandInvocationResult
  );

  // `invokeCommandOnServer` is a custom callback function the Elm port/command calls
  // to invoke a command on the server via websockets.
  const invokeCommandOnServer = (domainCommand) => {
    console.log('---> CommandChannel invoking domain command:');
    console.log(domainCommand);
    // send data to the server over the websocket channel
    // 'invoke' must correspond to a ruby method defined on this channel's corresponding Rails subclass
    // of ApplicationCable::Channel on the server.
    const commandConnectionSendResult = channel.perform('invoke', domainCommand);
    // return values of outbound port callback functions are ignored by Elm, so we will send it back via an inbound port
    // All ActionCable gives us from channel.perform is true or false based if connection was open or not, so send that
    elmApp.ports.receiveCommandConnectionSendResult.send(commandConnectionSendResult);
  };

  // subscribe to an "outgoing" Elm port/command on the client with an ActionCable callback function which will
  // invoke a command the server via websockets
  elmApp.ports.invokeCommandOnServer.subscribe(invokeCommandOnServer);
};

exports.setupCommandChannel = setupCommandChannel;
