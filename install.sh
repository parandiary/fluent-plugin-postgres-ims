#!/bin/bash

gem build fluent-plugin-postgres-ims.gemspec
gem install fluent-plugin-postgres-ims-0.1.0.gem

systemctl restart td-agent
