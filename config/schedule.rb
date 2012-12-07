# whenever --update-crontab bgm_tweet_update

# setup
# job_type :command, ":task :output"
# job_type :rake,    "cd :path && RAILS_ENV=:environment bundle exec rake :task --silent :output"
# job_type :runner,  "cd :path && script/rails runner -e :environment ':task' :output"

every 5.minutes do
  rake "tweet_collect:start"
end