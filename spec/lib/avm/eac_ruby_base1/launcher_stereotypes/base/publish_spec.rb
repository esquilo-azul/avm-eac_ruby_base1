# frozen_string_literal: true

require 'avm/projects/stereotypes'
require 'avm/launcher/context'

RSpec.describe ::Avm::EacRubyBase1::LauncherStereotypes::Base::Publish do
  describe '#publish' do
    let(:instance) { ::Avm::Launcher::Context.current.instance('/ruby_gem_stub') }

    it 'dries run publish for Ruby Gems' do # rubocop:disable RSpec/ExampleLength
      allow_any_instance_of(described_class).to receive(:gem_versions_uncached).and_return([]) # rubocop:disable RSpec/AnyInstance
      expect(instance).to be_a ::Avm::Launcher::Instances::Base
      ::Avm::Launcher::Context.current.publish_options = {
        confirm: false, new: true, stereotype: 'RubyGem'
      }
      described_class.new(instance).run
    end
  end
end
