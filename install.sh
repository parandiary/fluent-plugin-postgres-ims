#!/bin/bash

git pull

gem build fluent-plugin-postgres-ims.gemspec

gem push fluent-plugin-postgres-ims-0.1.1.gem 

td-agent-gem install fluent-plugin-postgres-ims 

# gem install fluent-plugin-postgres-ims-0.1.0.gem

#gem push fluent-plugin-postgres-ims-0.1.0.gem

systemctl restart td-agent
