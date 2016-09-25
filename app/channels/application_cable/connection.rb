# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      current_user = cookies['current_user']
      self.current_user = current_user
      Rails.logger.debug("\n\n<--- ActionCable::Connection received 'connect' with current_user: #{current_user}\n")
    end
  end
end
