# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter/bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'twitter-bot'
  spec.version       = Twitter::Bot::VERSION
  spec.authors       = ['Heather Rivers']
  spec.email         = ['git@heatherrivers.com']
  spec.description   = 'Twitter autoreply bot'
  spec.summary       = 'Search Twitter for specific terms and automatically ' \
                       'reply from your bot account.'
  spec.homepage      = 'https://github.com/rivers/twitter-bot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'

  spec.add_dependency 'twitter', '~> 5.14.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
