#!/bin/bash

set -ueo pipefail

echo "--- system details"
uname -a
ruby -v
bundle --version

echo "--- bundle install"
bundle config --local path vendor/bundle
bundle install --jobs=7 --retry=3 --without tools maintenance deploy

echo "+++ bundle exec rake lint"
bundle exec rake lint

echo "+++ bundle exec rake"
bundle exec rake
