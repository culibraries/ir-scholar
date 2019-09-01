#!/bin/sh

if [ "${RAILS_ENV}" = 'production' ]; then
  echo "Bundle install without development or test gems."
  bundle install --without development test -j $(nproc)
else
  bundle install --without production -j $(nproc)
fi
