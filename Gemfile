source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3']

gem 'rake'
gem 'puppet', puppetversion

group :tests do
  gem 'facter', '>= 2.4.0'
  gem 'puppetlabs_spec_helper', '>= 0.10.0'
  gem 'puppet-lint', '>= 2.3.0'
  gem 'rspec-puppet', '>= 2.4.0'
end

group :docs do
  gem 'puppet-strings'
end

