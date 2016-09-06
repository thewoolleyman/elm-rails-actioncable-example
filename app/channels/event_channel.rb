# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class EventChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'event_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def get_events_since(sequence)
    Rails.logger.debug("\n\n<--- EventChannel received 'getEventsSince' with sequence: #{sequence}\n")

    events = Event.where('sequence > ?', sequence.fetch('data')).order(:sequence)
    events_payload = events.map do |event|
      {
        id: event.id.to_s,
        sequence: event.sequence,
        type: event.type,
        data: JSON.load(event.data),
      }
    end

    EventsBroadcastJob.perform_later(events_payload)

    nil # be explicit that return value doesn't matter
  end
end
