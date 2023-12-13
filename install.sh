#!/bin/bash

git fetch --all
git reset --hard origin/master
git pull

echo ''
echo ''
echo '===============  td-agent-gem process ======================================'
td-agent-gem build fluent-plugin-postgres-ims.gemspec
td-agent-gem install fluent-plugin-postgres-ims-0.1.1.gem
td-agent-gem list | grep ims


echo ''
echo ''
echo '===============  gem process ======================================'
gem build fluent-plugin-postgres-ims.gemspec
gem push fluent-plugin-postgres-ims-0.1.1.gem 




# gem install fluent-plugin-postgres-ims-0.1.0.gem

#gem push fluent-plugin-postgres-ims-0.1.0.gem

systemctl restart td-agent
