# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class CommandChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'command_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def invoke(command_payload)
    Rails.logger.debug("\n\n<--- CommandChannel received 'invoke' with command_payload: #{command_payload}\n")
    command_invocation_result = CqrsEs::CommandInvoker.new.invoke_command(command_payload)

    # Rails discards the return value of inbound channel methods, it never reaches the
    # invoking client.  Therefore, we must send the result to the client on the outbound channel
    ActionCable.server.broadcast('command_channel', command_invocation_result)

    nil # be explicit that return value doesn't matter
  end
end
