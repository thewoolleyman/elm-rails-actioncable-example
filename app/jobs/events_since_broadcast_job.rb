# :nodoc:
class EventsSinceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(current_user, events_payload)
    Rails.logger.debug("\n\n---> EventsSinceBroadcastJob sending events payload to " \
      "current_user #{current_user} on channel events_since_channel: #{events_payload.inspect}\n")
    EventsSinceChannel.broadcast_to(current_user, events_payload)
  end
end
