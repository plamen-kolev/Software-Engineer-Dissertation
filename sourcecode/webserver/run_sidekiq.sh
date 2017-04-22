#!/usr/bin/bash

service redis start && nohup bundle exec sidekiq &
