# frozen_string_literal: true

require 'eac_ruby_utils/rspec/default_setup'
::EacRubyUtils::Rspec.default_setup_create(::File.expand_path('..', __dir__))

require 'eac_ruby_utils/speaker'
require 'eac_ruby_utils/rspec/stub_speaker'
::EacRubyUtils::Speaker.context.push(::EacRubyUtils::Rspec::StubSpeaker.new)
