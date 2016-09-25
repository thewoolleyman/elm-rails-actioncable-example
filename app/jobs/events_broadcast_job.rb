# :nodoc:
class EventsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(events_payload)
    Rails.logger.debug("\n\n---> EventsBroadcastJob sending events payload on channel event_channel: #{events_payload.inspect}\n")
    ActionCable.server.broadcast('event_channel', events_payload)
  end
end
