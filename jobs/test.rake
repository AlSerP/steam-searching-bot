require 'date'
require 'logger'

namespace :test do
  task :write_to_file do
    File.write('/app/jobs/test_file.txt', "#{DateTime.now}\n")
  end
end
