Rails.application.routes.draw do
  root to: 'page#show'

  mount ActionCable.server => '/cable'
end
