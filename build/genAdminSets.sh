#!/bin/sh
rake db:migrate

bin/rails hyrax:default_admin_set:create
bin/rails hyrax:default_collection_types:create