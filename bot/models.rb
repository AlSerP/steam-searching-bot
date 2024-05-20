# Load models
Dir[File.join(__dir__, 'models/', '*.rb')].sort.each { |file| require_relative file }
