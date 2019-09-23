#!/bin/sh
bundle exec rails runner clearFedoraSolrDB.rb
bundle exec rails hyrax:default_admin_set:create
bundle exec rails runner setupAdminSet.rb
bundle exec rails hyrax:default_collection_types:create
bundle exec rails hyrax:workflow:load
bundle exec rails runner 'Role.create(name: "admin")'
