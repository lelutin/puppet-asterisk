task :tests do
  require 'puppetlabs_spec_helper/rake_tasks'
  PuppetSyntax.exclude_paths = ["spec/fixtures/**/*.pp", "vendor/**/*", "pkg/**/*"]
  # run syntax checks on manifests, templates and hiera data
  # also runs :metadata_lint
  Rake::Task[:validate].invoke
  # runs puppet-lint
  Rake::Task[:lint].invoke
  # runs unit tests
  Rake::Task[:spec].invoke
end

task :docs do
  require 'puppet-strings'
  PuppetStrings.generate(PuppetStrings::DEFAULT_SEARCH_PATTERNS)
end
