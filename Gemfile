source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'].to_s : ['>= 3.3']

gem 'puppet', puppetversion
gem 'rake'

group :tests do
  gem 'facter', '>= 2.4.0'
  # Use info from metadata.json for tests
  gem 'puppetlabs_spec_helper', '>= 0.10.0'
  gem 'puppet-lint', '>= 2.3.0'
  gem 'puppet_metadata'
  gem 'rspec-puppet', '>= 2.4.0'
  # This draws in rubocop and other useful gems for puppet tests
  gem 'voxpupuli-test'
end

group :docs do
  gem 'puppet-strings'
end
