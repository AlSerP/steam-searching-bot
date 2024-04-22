# Load all Bot::Messages::
require_relative 'messages/base'
Dir[File.join(__dir__, 'messages/', '*.rb')].each { |file| require_relative file }

module Bot
  module Messages
    
  end
end
