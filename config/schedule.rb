# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, {:error => "/var/log/cron_log.log", :standard => "/var/log/cron_log.log"}
# set :job_template, "/bin/bash -l -c ':job'"
job_type :custom_rake, "cd :path && bundle install && bundle exec rake :task --silent :output"

every 1.minute do
  custom_rake "test:write_to_file"
end
