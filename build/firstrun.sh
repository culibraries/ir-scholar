#!/bin/sh
bundle exec rails runner build/clearFedoraSolrDB.rb
bundle exec rails hyrax:default_admin_set:create
bundle exec rails hyrax:default_collection_types:create
bundle exec rails hyrax:workflow:load
bundle exec rails runner build/createAdminUser.rb
bundle exec rails runner build/setupAdminSet.rb
