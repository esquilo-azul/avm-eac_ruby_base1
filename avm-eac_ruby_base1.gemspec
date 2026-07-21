# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'avm/eac_ruby_base1/version'

Gem::Specification.new do |s|
  s.name        = 'avm-eac_ruby_base1'
  s.version     = Avm::EacRubyBase1::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.add_dependency 'aranha-parsers', '~> 0.29'

  s.files = Dir.glob('{lib,locale,template}/**/*', File::FNM_DOTMATCH)
              .reject { |f| ['.', '..'].include?(File.basename(f)) }
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'avm', '~> 0.102', '>= 0.102.1'
  s.add_dependency 'avm-eac_generic_base0', '~> 0.15', '>= 0.15.3'
  s.add_dependency 'eac_envs-http', '~> 0.7', '>= 0.7.1'
  s.add_dependency 'eac_ruby_base1', '~> 0.1'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.13'
end
