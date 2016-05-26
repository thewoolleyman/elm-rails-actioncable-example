# :nodoc:
class StateBroadcastJob < ApplicationJob
  queue_as :default

  def perform(state)
    Rails.logger.debug("\n\n---> StateBroadcastJob sending state to state_channel: #{state}\n")
    ActionCable.server.broadcast('state_channel', state)
  end
end
