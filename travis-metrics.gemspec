# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'travis/metrics/version'

Gem::Specification.new do |s|
  s.name          = 'travis-metrics'
  s.version       = Travis::Metrics::VERSION
  s.authors       = ['Travis CI']
  s.email         = 'contact@travis-ci.org'
  s.homepage      = 'https://github.com/travis-ci/travis-instrumentation'
  s.summary       = 'Instrumentation for Travis CI'
  s.description   = "#{s.summary}."
  s.licenses      = ['MIT']
  s.required_ruby_version = '~> 3.2'

  s.files         = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'metriks-librato_metrics', '~> 1.0'
end
