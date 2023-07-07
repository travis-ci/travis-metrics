# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'metriks', git: 'https://github.com/travis-ci/metriks', branch: 'dt-ror-update'
gem 'metriks-librato_metrics', git: 'https://github.com/travis-ci/metriks-librato_metrics'

group :test do
  gem 'riemann-client', '~> 0.0.7'
  gem 'rspec'
end

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'simplecov'
  gem 'simplecov-console'
end
