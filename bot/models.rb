# Load models
Dir[File.join(__dir__, 'models/', '*.rb')].each { |file| require_relative file }
