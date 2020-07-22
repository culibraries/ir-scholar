# CU Scholar Repository

Samvera Hyrax application for the deployment to k8s cluster.

### Branch Management

     <feature branch> --> develop --> release --> master

     `develop` is used for local development.
     Note:
      - For local development, make sure to comment out the line 15,16,17 in config/routes.rb and uncomment line 22.
      - Before merging to release, undo the previous step above to activate SAML.
     `release` includes SAML --> Testing Branch
     `master` production Branch - Requires PR to merge to master


### Setup Development Environment

1. Dependency
     * Java 1.8 This requirement is needed to start solr search
     * Ruby and rails.... on todo for addition dependencies.


### Debug Environment

    $ bin/rails hydra:server



TODO List !

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

RDS database see secrets for connections

* Database initialization

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
