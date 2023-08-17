source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'].to_s : ['>= 3.3']

gem 'puppet', puppetversion
gem 'rake'

group :tests do
  gem 'facter', '>= 2.4.0'
  gem 'metadata-json-lint', '~> 3.0'
  # Use info from metadata.json for tests
  gem 'puppetlabs_spec_helper', '>= 0.10.0'
  gem 'puppet-lint', '>= 2.3.0'
  # rubocop:disable Bundler/DuplicatedGem
  gem 'puppet_metadata', '~> 3.0', require: false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.7.0')
  gem 'puppet_metadata', '~> 2.1', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7.0')
  # rubocop:enable Bundler/DuplicatedGem
  gem 'puppet-syntax', '~> 3.3'
  gem 'rspec-puppet', '>= 2.4.0'
  # This draws in rubocop and other useful gems for puppet tests
  # rubocop:disable Bundler/DuplicatedGem
  gem 'voxpupuli-test', '~> 7.0', require: false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.7.0')
  gem 'voxpupuli-test', '~> 7.0', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7.0')
  # rubocop:enable Bundler/DuplicatedGem
end

group :docs do
  gem 'puppet-strings'
end
