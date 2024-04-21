# require_relative 'answers/hello'
# require_relative 'answers/bye'
# require_relative 'answers/unknown'
# require_relative 'answers/search'

# Load all .rb files from answers/
Dir["answers/*.rb"].each {|file| require_relative file }

module Answers
  
end
