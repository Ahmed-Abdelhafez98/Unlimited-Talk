#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f $APP_HOME/tmp/pids/server.pid

bundle exec sidekiq &

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"