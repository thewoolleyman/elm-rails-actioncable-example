require 'active_support'
# require 'active_support/rails'
# require 'active_job/version'
# require 'global_id'

module CqrsEs
  extend ActiveSupport::Autoload

  autoload :CommandInvoker
  autoload :Event
end
