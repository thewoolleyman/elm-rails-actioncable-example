class Event < ActiveRecord::Base
  before_save :set_sequence
  after_save :broadcast

  private

  def set_sequence
    max_sequence = Event.maximum(:sequence) || 0
    self.sequence = max_sequence + 1
  end

  def broadcast
    events_payload = [
      {
        eventId: self.id.to_s,
        sequence: sequence,
        type: type,
        data: JSON.load(data),
      }
    ]
    EventsBroadcastJob.perform_later(events_payload)
  end
end
