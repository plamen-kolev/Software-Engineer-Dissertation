#!/bin/bash
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb
