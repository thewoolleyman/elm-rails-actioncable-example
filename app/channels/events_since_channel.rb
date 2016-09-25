# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class EventsSinceChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def get_events_since(sequence)
    Rails.logger.debug("\n\n<--- EventChannel received 'getEventsSince' from " \
      "current_user #{current_user} with sequence: #{sequence}\n")

    events = Event.where('sequence > ?', sequence.fetch('data')).order(:sequence)
    events_payload = events.map do |event|
      {
        id: event.id.to_s,
        sequence: event.sequence,
        type: event.type,
        data: JSON.load(event.data),
      }
    end

    EventsSinceBroadcastJob.perform_later(current_user, events_payload)

    nil # be explicit that return value doesn't matter
  end
end
