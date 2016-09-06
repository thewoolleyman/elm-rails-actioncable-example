'use strict';

/*
 setupCommandChannel() is one of two javascript shims between ActionCable and Elm ports.
 The duplication between them could be DRYed up, but they are left separate in this example app for clarity.
 This one is for outbound commands being sent from the Elm client to the server and their (inbound) results.
 */
const setupCommandChannel = (elmApp, actionCable) => {
  // 'CommandChannel' must correspond to a Rails subclass of ApplicationCable::Channel on the server.
  const channel = actionCable.subscriptions.create('CommandChannel', {
    connected() {
      // called when websocket channel is connected - notify "incoming" Elm port/subscription
      elmApp.ports.receiveCommandChannelStatus.send('connected channel with identifier: ' + this.identifier);
    },

    disconnected() {
      // called when websocket channel is disconnected - notify "incoming" Elm port/subscription
      elmApp.ports.receiveCommandChannelStatus.send('disconnected channel with identifier: ' + this.identifier);
    },

    // `received` is the standard function ActionCable calls when `ActionCable.server.broadcast` is
    // invoked via Rails on the server to send data to the client on this channel via websockets.
    // i.e. the single server -> client websocket connection for this channel
    received(commandInvocationResult) {
      console.log('<--- CommandChannel received commandInvocationResult:');
      console.log(commandInvocationResult);
      // send data received from the server on this ActionCable websocket channel to an "incoming" Elm port/subscription
      elmApp.ports.receiveCommandInvocationResult.send(commandInvocationResult);
    },
  });

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
