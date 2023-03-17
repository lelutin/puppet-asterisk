source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 3.3']

gem 'rake'
gem 'puppet', puppetversion

group :tests do
  gem 'facter', '>= 2.4.0'
  gem 'puppetlabs_spec_helper', '>= 0.10.0'
  gem 'puppet-syntax', '~> 3.3'
  gem 'puppet-lint', '>= 2.3.0'
  gem 'metadata-json-lint', '~> 3.0'
  # This draws in rubocop and other useful gems for puppet tests
  gem 'voxpupuli-test', '~> 5.6', :require => false
  # Use info from metadata.json for tests
  gem 'puppet_metadata', '~> 2.0', :require => false
  gem 'rspec-puppet', '>= 2.4.0'
end

group :docs do
  gem 'puppet-strings'
end

