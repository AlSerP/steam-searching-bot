# Load all Bot::Handlers::
require_relative 'handlers/base'
Dir[File.join(__dir__, 'handlers/', '*.rb')].sort.each { |file| require_relative file }

module Bot
  module Handlers
  end
end
