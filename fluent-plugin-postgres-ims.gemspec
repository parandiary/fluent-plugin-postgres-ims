# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name          = 'fluent-plugin-postgres-ims'
  s.version       = '0.1.1'
  s.authors       = ['hhchoi']
  s.email         = ['parandiary@gmail.com']
  s.description   = %q{fluent plugin to insert on PostgreSQL (add readonly option coffig)}
  s.summary       = %q{fluent plugin to insert on PostgreSQL (add readonly option coffig)}
  s.homepage      = 'https://github.com/parandiary/fluent-plugin-postgres-ims'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'fluentd', ['>= 0.14.15', '< 2']
  s.add_dependency 'pg'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit', '~> 3.2.0'
end
