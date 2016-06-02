# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class StateChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'state_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update(payload)
    Rails.logger.debug("\n\n<--- StateChannel received payload: #{payload}\n")
    model = Model.find_by_id(1)
    unless model
      model = Model.create(id: 1, state: '')
    end
    state = payload.fetch('state')
    model.update_attributes!(state: state)
  end
end
