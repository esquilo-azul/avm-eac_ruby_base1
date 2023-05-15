# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'avm/eac_ruby_base1/version'

Gem::Specification.new do |s|
  s.name        = 'avm-eac_ruby_base1'
  s.version     = Avm::EacRubyBase1::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib,locale,template}/**/*']

  s.add_dependency 'aranha-parsers', '~> 0.18'
  s.add_dependency 'avm', '~> 0.71'
  s.add_dependency 'avm-eac_generic_base0', '~> 0.12'
  s.add_dependency 'eac_ruby_utils', '~> 0.112'

  s.add_development_dependency 'aranha-parsers', '~> 0.14', '>= 0.14.1'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
