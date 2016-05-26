class Model < ApplicationRecord
  after_save :broadcast_state_update

  private

  def broadcast_state_update
    StateBroadcastJob.perform_later(self.state)
  end
end
